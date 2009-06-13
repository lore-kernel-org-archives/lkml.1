Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZFME5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZFME5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 00:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZFME5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 00:57:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54026 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZFME5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 00:57:33 -0400
Date: Sat, 13 Jun 2009 01:39:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, markmc@redhat.com,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [KVM PATCH v6 2/2] KVM: add iosignalfd support
Message-ID: <20090613043951.GA3083@amt.cnet>
References: <20090605154006.18047.41232.stgit@dev.haskins.net> <20090605155508.18047.83818.stgit@dev.haskins.net> <4A29417A.6070706@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A29417A.6070706@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 12:02:02PM -0400, Gregory Haskins wrote:
> Hi Marcelo!
> 
> Comments about the shutdown path ambiguity are in-line
> 
> Gregory Haskins wrote:
> > iosignalfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
> > signal when written to by a guest.  Host userspace can register any arbitrary
> > IO address with a corresponding eventfd and then pass the eventfd to a
> > +		list_del(&item->list);
> > +		iosignalfd_item_free(item);
> > +	}
> > +
> > +	list_del(&group->list);
> > +	kfree(group);
> > +}
> >   
> 
> So this function is called by the path that executes as we do the last
> kvm_put_kvm().  I do not do any careful RCU wrangling here because I
> assume that there cannot possibly be any active MMIO/PIO operations at
> this time, or the reference would never have dropped.  Let me know if
> anyone sees any holes in that.
> 
> An alternative approach is to do this similar to how irqfd_release()
> works.   That is: invoke it from the vmfd release() path instead of the
> the kvm object destructor.  I currently do not think this is necessary,
> but I will throw that out there in case someone likes it better.

Gregory,

Can't see any problems with it. You might want an upper limit
in the number of items per group.
