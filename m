Return-Path: <linux-kernel-owner+w=401wt.eu-S936127AbXGSIwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936127AbXGSIwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbXGSIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:52:34 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:37180 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbXGSIwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:52:34 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 10:52:16 +0200
User-Agent: KMail/1.9.4
Cc: Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707190849.05983.juergen127@kreuzholzen.de> <20070719031712.bda40333.dilinger@queued.net>
In-Reply-To: <20070719031712.bda40333.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CZynGSru0nmgUdl"
Message-Id: <200707191052.18107.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CZynGSru0nmgUdl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 19 July 2007 09:17, Andres Salomon wrote:
> On Thu, 19 Jul 2007 08:49:05 +0200
>
> Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > On Thursday 19 July 2007 03:02, Andrew Morton wrote:
> > > On Sun, 15 Jul 2007 21:06:27 +0200
> > >
> > > Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > > > Replace NSC/Cyrix specific chipset access macros by inlined
> > > > functions. With the macros a line like this fails (and does nothing):
> > > > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > > > With inlined functions this line will work as expected.
> > >
> > > I don't get it.  Why would the macros behave differently from inlined
> > > functions?
> >
> > X86 magic. The access order is important. The first access must always be
> > the offset at 0x22. This access enables the next access to 0x23 (data).
> > If you do it in wrong order, it fails. With the macros you get something
> > like 0x22, 0x22, 0x23, 0x23. With the inline functions
> > 0x22,0x23,0x22,0x23.
> >
> > Juergen
>
> Wow, that's a really cool bug; nice work!  Don't forget to update
> arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It
> needs to include processor-cyrix.h.
>
>
> Acked-by: Andres Salomon <dilinger@debian.org>

Missing include patch attached. Thanks.

Juergen



--Boundary-00=_CZynGSru0nmgUdl
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="missing-include.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="missing-include.patch"

Index: arch/i386/kernel/cpu/mtrr/state.c
===================================================================
--- arch/i386/kernel/cpu/mtrr/state.c
+++ arch/i386/kernel/cpu/mtrr/state.c
@@ -3,6 +3,7 @@
 #include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"



--Boundary-00=_CZynGSru0nmgUdl--
