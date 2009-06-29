Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZF2REp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZF2REp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZF2REi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:04:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZF2REi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:04:38 -0400
Date: Mon, 29 Jun 2009 14:04:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       markmc@redhat.com
Subject: Re: [PATCHv3 3/4] kvm: convert bus to slots_lock
Message-ID: <20090629170418.GA17937@amt.cnet>
References: <cover.1246276816.git.mst@redhat.com> <20090629120911.GD21273@redhat.com> <20090629155031.GA16444@amt.cnet> <20090629163851.GD22029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629163851.GD22029@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:38:51PM +0300, Michael S. Tsirkin wrote:
> On Mon, Jun 29, 2009 at 12:50:31PM -0300, Marcelo Tosatti wrote:
> > > diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> > > index 148c52a..1851aec 100644
> > > --- a/arch/x86/kvm/i8259.c
> > > +++ b/arch/x86/kvm/i8259.c
> > > @@ -548,6 +548,6 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
> > >  	 * Initialize PIO device
> > >  	 */
> > >  	kvm_iodevice_init(&s->dev, &picdev_ops);
> > > -	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
> > > +	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
> > >  	return s;
> > 
> > case KVM_CREATE_PIT2:
> > create_pit:
> > mutex_lock(&kvm->lock);
> > kvm_io_bus_register_dev
> > down_write(slots_lock);
> > 
> > But the order is slots_lock -> kvm->lock.
> > 
> > (you might want to update the comment on top of kvm_main.c to 
> > reflect that).
> 
> Good catch. I think it's easiest to replace kvm->lock by slots_lock
> here as well. Does something like the following make sense?
> If yes I'll roll it up in the series.

Looks good. Also please update the comment on top of kvm_main.c.

