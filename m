Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZFWLqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZFWLqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZFWLqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:46:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53240 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZFWLqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:46:45 -0400
Date: Tue, 23 Jun 2009 14:46:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
Message-ID: <20090623114621.GE17635@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A40A5D5.4080208@redhat.com> <4A40BF58.8060603@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40BF58.8060603@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:41:12AM -0400, Gregory Haskins wrote:
> Avi Kivity wrote:
> > On 06/22/2009 07:08 PM, Michael S. Tsirkin wrote:
> >> On Mon, Jun 22, 2009 at 11:45:00AM -0400, Gregory Haskins wrote:
> >>   
> >>> Michael S. Tsirkin wrote:
> >>>     
> >>>> It seems that a lot of complexity and trickiness with iosignalfd is
> >>>> handling the group/item relationship, which comes about because kvm
> >>>> does
> >>>> not currently let a device on the bus claim a write transaction
> >>>> based on the
> >>>> value written.  This could be greatly simplified if the value written
> >>>> was passed to the in_range check for write operation.  We could then
> >>>> simply make each kvm_iosignalfd a device on the bus.
> >>>>
> >>>> What does everyone think of the following lightly tested patch?
> >>>>
> >>>>        
> >>> Hi Michael,
> >>>    Its interesting, but I am not convinced its necessary.  We
> >>> created the
> >>> group/item layout because iosignalfds are unique in that they are
> >>> probably the only IO device that wants to do some kind of address
> >>> aliasing.
> >>>      
> >>
> >> We actually already have aliasing: is_write flag is used for this
> >> purpose. Actually, it's possible to remove is_write by passing
> >> a null pointer in write_val for reads. I like this a bit less as
> >> the code generated is less compact ... Avi, what do you think?
> >>    
> >
> > Greg, won't Michael's patch eliminate a big chunk from your iosignalfd
> > patches?  Seems like a win to me.
> 
> Well, it really just moves that hunk from eventfd.c to kvm_main.c, where
> I don't think anyone else will use it by iosignalfd.  But if that is
> what everyone wants, I guess I have no choice.

Wait a bit before you start rebasing though please.
I just had a brainwave and is rewriting this patch.

> >
> >> One is enough :)
> >> Seriously, do you see that this saves you all of RCU, linked lists and
> >> counters? You don't need to keep track of iofds, you don't need to
> >> implement your own lookup logic - you just use the kvm device
> >> and that's it.
> >>
> >>    
> >
> > Yup.
> >
> 
> 


