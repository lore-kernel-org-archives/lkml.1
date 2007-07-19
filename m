Return-Path: <linux-kernel-owner+w=401wt.eu-S935046AbXGSHPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbXGSHPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXGSHPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:15:00 -0400
Received: from mail.queued.net ([207.210.101.209]:2109 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052AbXGSHO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:14:59 -0400
Date: Thu, 19 Jul 2007 03:17:12 -0400
From: Andres Salomon <dilinger@queued.net>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu
 unstable
Message-Id: <20070719031712.bda40333.dilinger@queued.net>
In-Reply-To: <200707190849.05983.juergen127@kreuzholzen.de>
References: <20070715.210036.157242351.takada@mbf.nifty.com>
	<200707152106.28437.juergen127@kreuzholzen.de>
	<20070718180223.e1dad55d.akpm@linux-foundation.org>
	<200707190849.05983.juergen127@kreuzholzen.de>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 08:49:05 +0200
Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> On Thursday 19 July 2007 03:02, Andrew Morton wrote:
> > On Sun, 15 Jul 2007 21:06:27 +0200
> >
> > Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > > Replace NSC/Cyrix specific chipset access macros by inlined functions.
> > > With the macros a line like this fails (and does nothing):
> > > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > > With inlined functions this line will work as expected.
> >
> > I don't get it.  Why would the macros behave differently from inlined
> > functions?
> 
> X86 magic. The access order is important. The first access must always be the 
> offset at 0x22. This access enables the next access to 0x23 (data). If you do 
> it in wrong order, it fails. With the macros you get something like 0x22, 
> 0x22, 0x23, 0x23. With the inline functions 0x22,0x23,0x22,0x23.
> 
> Juergen

Wow, that's a really cool bug; nice work!  Don't forget to update
arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It needs
to include processor-cyrix.h.


Acked-by: Andres Salomon <dilinger@debian.org>

-- 
Andres Salomon <dilinger@queued.net>
