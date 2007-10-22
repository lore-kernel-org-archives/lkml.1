Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXJVEp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXJVEp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJVEpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:45:50 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25732 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751139AbXJVEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:45:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=POTxb7XtXDXVXF5OmqUaS+Q1uOttvO41sgih9zniHHooeCWFQMsgSADrNWCNRPI88dsI3jP6SGwLTW/vnD0Ew6PEuj9OAGMl8amKO1442F45WUIO/MKXpftUB4345IfbCxPcL0iuGF4rXemigiub9Y74dAXXFk8nv23FPNILyo0=  ;
X-YMail-OSG: unlB55wVM1nPPiI5CbLS5NcaytrpQ60oVcWjYaZimQkAkIDWqxOu07p0A5sw3tzQPZjuU3xk2Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: dean gaudet <dean@arctic.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Date: Mon, 22 Oct 2007 14:39:21 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
References: <470FA7C3.90404@goop.org> <471C1A61.1010001@goop.org> <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221439.21503.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 14:28, dean gaudet wrote:
> On Sun, 21 Oct 2007, Jeremy Fitzhardinge wrote:
> > dean gaudet wrote:
> > > On Mon, 15 Oct 2007, Nick Piggin wrote:
> > >> Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
> > >> because it generally has to invalidate TLBs on all CPUs.
> > >
> > > why is that?  ignoring 32-bit archs we have heaps of address space
> > > available... couldn't the kernel just burn address space and delay
> > > global TLB invalidate by some relatively long time (say 1 second)?
> >
> > Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> > stray mappings, which upsets Xen.
>
> sounds like a bug in xen to me :)

You could call it a bug I think. I don't know much about Xen though,
whether or not it expects to be able to run an arbitrary OS kernel.

Presumably, the hypervisor _could_ write protect and trap writes to
*all* page table page mappings.
