Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZHNMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZHNMiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZHNMiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:38:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZHNMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:38:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: implementing Futex
Date: Fri, 14 Aug 2009 14:38:01 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A8550CF.8000003@lumino.de>
In-Reply-To: <4A8550CF.8000003@lumino.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141438.01392.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Q5OJ3mCFnR/30lyKDG7AMlPnHlig5RcSTLlb
 16LYYMOaOdIQxfQCbZAHW3+gwdQP4xqPDiZ/5Ah+hXhVrTBaKh
 xaJbsXymW1ituYmgsHsig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Michael Schnell wrote:
> Arnd Bergmann wrote:,
> >> From reading the code (futex_atomic_op_inuser() seems only to be called
> >> once (in futex.c) ), it seems that futex_atomic_op_inuser() is not
> >> really used at all. It seems that it'd only called for futex_wake, and
> >> here the "Operation" is derived from the last parameter of the system
> >> call, which the man page says is ignored.  So, are all the operations
> >> implemented there really necessary or just "nice to have" ?
> >
> > You misread futex_wake_op(). The operation comes from the second parameter
> > of the syscall, not the last one.
> 
> Really ?

Sorry, I misread the code as well, in a different way :(

> What am I getting wrong ?
> 
> But I also don't see how this makes any sense.

The man page says that the last parameter is ignored for op=FUTEX_WAKE,
which is correct. The code that you were looking at however is for
of=FUTEX_WAKE_OP, which is not documented as of manpages-3.22.

It was added by Jakub back in 2005, but if he wrote a documentation
for it, it never went into the man pages package. On a similar
note, Ingo also added other futex operations that are not documented
yet.

	Arnd <><
