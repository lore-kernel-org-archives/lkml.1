Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZGHHsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZGHHsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZGHHsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:48:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48806 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbZGHHsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:48:30 -0400
Date: Wed, 8 Jul 2009 10:47:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 1/2] KVM: make io_bus interface more robust
Message-ID: <20090708074742.GA10803@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203315.14222.25490.stgit@dev.haskins.net> <20090707112035.GB3647@redhat.com> <4A538533.3030703@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A538533.3030703@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:26:11PM -0400, Gregory Haskins wrote:
> These patches pass checkpatch.pl and I happen to like the extra
> whitespace for readability.  I agree that a random isolated whitespace
> hunk, or double whitespace in a row are probably inadvertent and should
> be pointed out.  But these little one liners in the middle of code I
> generally do on purpose (for instance, [A]).

Where it's on purpose, it's on purpose. I am just trying to convey a
rather obvious point that each line of code should have a purpose in
life, and that includes empty lines :)

> I suppose its personal preference either way, so I guess unless Avi
> objects lets just each have our own style in that regard.

I think Avi already said we don't need to standardize everything.
I hope at least some of the comments were helpful.

> >> @@ -552,6 +554,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
> >>  	 * Initialize PIO device
> >>  	 */
> >>  	kvm_iodevice_init(&s->dev, &picdev_ops);
> >> -	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> >> +	ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> >> +	if (ret < 0) {
> >>     
> >
> > I thought the function returns 0 on success?
> > If so can we just if (ret) all over?
> >
> >   
> 
> I guess, but what does that churn buy us?

It's not that important really. I think we need to document the return
value, and check it according to how it is documented. The reason I
commented, I see < 0 and ask "what if it is > 0"? I look it up and it
turns out it's never > 0.  So why check < 0?

> >> +	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
> >> +	if (ret < 0)
> >> +		kfree(dev);
> >> +
> >>     
> >
> > kill empty line
> >   
> 
> Why do you object here especially when there is precedence

How do you mean, precedence?

> with
> something like the space before the return with [B]?  I think big
> mono-blocks of code are ugly and harder to read, personally.

I don't intend to keep arguing and I agree it's a question of style.
But since you ask why I'll try to answer. I think an
empty line should help delimit a block of code with some common meaning,
like a paragraph.  But if overused it loses meaning and stops being
helpful.

E.g., it does not make sense to put it between every 2 lines of code in a
function.  It also does not make sense to put it after } which is
already delimiting a block in a visible way; it does not make sense to
put it around a multiline comment which is delimited by /**/.  It does
not make sense to put it around an idented block which is already
delimited by indentation.

> >> +		if (bus->devs[i] == dev) {
> >> +			bus->devs[i] = bus->devs[--bus->dev_count];
> >> +			break;
> >> +		}
> >> +	}
> >>     
> >
> > no {} around single statement


This is actually part of style IMO, it is just hard for a perl script to
catch :).

> >
> >   
> >>  }
> >>  
> >>  static struct notifier_block kvm_cpu_notifier = {
> >>     
> 
> 


