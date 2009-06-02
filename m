Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZFBQVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZFBQVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZFBQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:21:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbZFBQVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:21:15 -0400
Date: Tue, 2 Jun 2009 19:20:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
Message-ID: <20090602162021.GB6827@redhat.com>
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A254FD7.5090302@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 12:14:15PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Tue, Jun 02, 2009 at 11:15:28AM -0400, Gregory Haskins wrote:
> >   
> >> (Applies to kvm.git/master:25deed73)
> >>
> >> Please see the header for 2/2 for a description.  This patch series has
> >> been fully tested and appears to be working correctly.  I have it as an RFC
> >> for now because it needs Davide's official submission/SOB for patch 1/2, and
> >> it should get some eyeballs/acks on my SRCU usage before going in.
> >>
> >> I will submit the updated irqfd userspace which eschews the deassign() verb
> >> since we can now just use the close(fd) method alone.  I will also address
> >> the userspace review comments from Avi.
> >>     
> >
> >
> > We are not killing the deassign though, do we?
> >   
> 
> Yes, it is not needed any more now that we have proper
> release-notification from eventfd.
> 
> > It's good to have that option e.g. for when we pass
> > the fd to another process.
> >   
> 
> Passing the fd to another app should up the underlying file reference
> count.  If the producer app wants to "deassign" it simply calls
> close(fd) (as opposed to today where it calls DEASSIGN+close), but the
> reference count will allow the consuming app to leave the eventfd's file
> open.  Or am I misunderstanding you?
> 
> -Greg
> 
> 

I think we want to keep supporting the deassign ioctl. This, even though
close overlaps with it functionally somewhat.

This allows qemu to pass eventfd to another process/device, and then
block/unblock interrupts as seen by that process by
assigning/deassigning irq to it. This is much easier and lightweight
than asking another process to close the fd and passing another fd
later.

-- 
MST
