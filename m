Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYHDOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYHDOyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYHDOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:54:12 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64826 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbYHDOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:54:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18583.6153.542598.838960@harpo.it.uu.se>
Date: Mon, 4 Aug 2008 16:54:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Opteron Rev E has a bug ... a locked  instruction doesn't act as a read-acquire barrier
In-Reply-To: <200808041556.05339.arekm@maven.pl>
References: <200808031106.12366.arekm@maven.pl>
	<18583.883.70907.983634@harpo.it.uu.se>
	<200808041556.05339.arekm@maven.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 15:56:05 +0200, Arkadiusz Miskiewicz wrote:
>On Monday 04 August 2008, Mikael Pettersson wrote:
>> Arkadiusz Miskiewicz writes:
>>  > Hello,
>>  >
>>  > http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/=
>at
>>  >omicops-internals-x86.cc says
>>  >
>>  > "  // Opteron Rev E has a bug in which on very rare occasions a locked
>>  >   // instruction doesn't act as a read-acquire barrier if followed by a
>>  >   // non-locked read-modify-write instruction.  Rev F has this bug in
>>  >   // pre-release versions, but not in versions released to customers,
>>  >   // so we test only for Rev E, which is family 15, model 32..63
>>  > inclusive. if (strcmp(vendor, "AuthenticAMD") =3D=3D 0 &&       // AMD
>>  >       family =3D=3D 15 &&
>>  >       32 <=3D model && model <=3D 63) {
>>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug =3D true;
>>  >   } else {
>>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug =3D false;
>>  >   }
>>  > "
>>  >
>>  > does kernel have quirk/workaround for this? I'm looking at
>>  > arch/x86/kernel/cpu but I don't see workaround related to this (possib=
>ly
>>  > I'm overlooking).
>>
>> I can find no reference to this alleged RevE erratum in the
>> Athlon64/Opteron revision guide (25759.pdf).
>>
>> But if this bug is real then we need to know about it. Could
>> you ask the author of the code you quoted above to clarify?
>
>Got answer, opensolaris has some workarounds for this bug I still don't kno=
>w=20
>which errata # is that:
>
>http://groups.google.com/group/google-perftools/browse_thread/thread/3d1b78=
>d4a9db8c6e
>
>btw. I got info about this bug after hiting this problem:=20
>http://bugs.mysql.com/bug.php?id=3D26081

Thanks, found the Solaris code in question and the mysql discussion.
I'll dig deeper tomorrow.

/Mikael
