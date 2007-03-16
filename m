Return-Path: <linux-kernel-owner+w=401wt.eu-S965363AbXCPPD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbXCPPD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXCPPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:03:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:42579 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363AbXCPPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:03:26 -0400
Date: Fri, 16 Mar 2007 16:01:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
Message-ID: <20070316150145.GB8525@osiris.boeblingen.de.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAA39C.9050705@us.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 09:03:08AM -0500, Anthony Liguori wrote:
> Heiko Carstens wrote:
> >On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
> >  
> >>This patchset updates the kvm userspace interface to what I hope will
> >>be the long-term stable interface.  Provisions are included for extending
> >>the interface later.  The patches address performance and cleanliness
> >>concerns.
> >>    
> >
> >Searching the mailing list I figured that as soons as the interface seems
> >to be stable, kvm should/would switch to a system call based interface.
> >I assume the userspace interface might still change a lot, especially if
> >kvm is ported to new architectures.
> >But the general question is: do you still plan to switch to a syscall
> >interface?
> >  
> 
> What benefit would a syscall interface have?

First of all: it's faster and doesn't burn a bunch of additional cpu
cycles like sys_ioctl and the large switch statements do.

Another thing is that this patch set already introduces a way to pass a
sigset. Passing a sigset to a device node is sort of strange.

In addition, if we would port kvm to s390, then we would need to
make sure that each virtual cpu only gets executed from the thread
that created it. That is simply because the upper half of our page
tables contain information about the guest page states. This is yet
another thing that would be strange to do via an ioctl based interface.

Of course everthing can be done via an iotcl interface too, but IMHO
that's just the wrong interface.
