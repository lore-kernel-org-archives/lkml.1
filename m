Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYHDN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYHDN4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYHDN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:56:09 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:30923 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbYHDN4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:56:08 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: Opteron Rev E has a bug ... a locked  instruction doesn't act as a read-acquire barrier
Date: Mon, 4 Aug 2008 15:56:05 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: Mikael Pettersson <mikpe@it.uu.se>
References: <200808031106.12366.arekm@maven.pl> <18583.883.70907.983634@harpo.it.uu.se>
In-Reply-To: <18583.883.70907.983634@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808041556.05339.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008, Mikael Pettersson wrote:
> Arkadiusz Miskiewicz writes:
>  > Hello,
>  >
>  > http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/at
>  >omicops-internals-x86.cc says
>  >
>  > "  // Opteron Rev E has a bug in which on very rare occasions a locked
>  >   // instruction doesn't act as a read-acquire barrier if followed by a
>  >   // non-locked read-modify-write instruction.  Rev F has this bug in
>  >   // pre-release versions, but not in versions released to customers,
>  >   // so we test only for Rev E, which is family 15, model 32..63
>  > inclusive. if (strcmp(vendor, "AuthenticAMD") == 0 &&       // AMD
>  >       family == 15 &&
>  >       32 <= model && model <= 63) {
>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = true;
>  >   } else {
>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug = false;
>  >   }
>  > "
>  >
>  > does kernel have quirk/workaround for this? I'm looking at
>  > arch/x86/kernel/cpu but I don't see workaround related to this (possibly
>  > I'm overlooking).
>
> I can find no reference to this alleged RevE erratum in the
> Athlon64/Opteron revision guide (25759.pdf).
>
> But if this bug is real then we need to know about it. Could
> you ask the author of the code you quoted above to clarify?

Got answer, opensolaris has some workarounds for this bug I still don't know 
which errata # is that:

http://groups.google.com/group/google-perftools/browse_thread/thread/3d1b78d4a9db8c6e

btw. I got info about this bug after hiting this problem: 
http://bugs.mysql.com/bug.php?id=26081

> /Mikael

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
