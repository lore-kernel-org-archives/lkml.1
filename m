Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZFWLhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZFWLhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZFWLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:37:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZFWLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:36:59 -0400
Date: Tue, 23 Jun 2009 14:36:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
Message-ID: <20090623113634.GC17635@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090623085633.GA16294@redhat.com> <4A40BD73.8050902@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40BD73.8050902@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:33:07AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
> >   
> >> +static int
> >> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
> >> +			  int is_write)
> >> +{
> >> +	struct _iosignalfd_group *p = to_group(this);
> >> +
> >> +	return ((addr >= p->addr && (addr < p->addr + p->length)));
> >> +}
> >>     
> >
> > I think I see a problem here. For virtio, we do not necessarily want all
> > virtqueues for a device to live in kernel: there might be control
> > virtqueues that we want to leave in userspace. Since this claims all
> > writes to a specific address, the signal never makes it to userspace.
> >
> >   
> You can use a wildcard.  Would that work?
> 

Nope, you need to know the value written.

