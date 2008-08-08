Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYHHMKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYHHMKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYHHMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:09:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:53457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYHHMJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:09:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
Date: Fri, 8 Aug 2008 14:09:29 +0200
User-Agent: KMail/1.9.9
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <20080807224035.E56663BF@kernel>
In-Reply-To: <20080807224035.E56663BF@kernel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081409.30591.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hvoCNzS15q2af5bAlba0wcteqcO+U3339XEn
 5QNP0BCqQVxX2J1ai7zjRzUTRa3DOlQisu2WwT6n2tmAkBT1Bd
 cTDQBFX/AKAhRm/usE/6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> diff -puN /dev/null include/asm-x86/ckpt.h
> --- /dev/null	2007-04-11 11:48:27.000000000 -0700
> +++ linux-2.6.git-dave/include/asm-x86/ckpt.h	2008-08-04 13:29:59.000000000 -0700
> @@ -0,0 +1,46 @@

> +
> +struct cr_hdr_cpu {
> +        __u64 bx;
> +        __u64 cx;
> +        __u64 dx;
> +        __u64 si;
> +        __u64 di;
> +        __u64 bp;
> +        __u64 ax;
> +        __u64 ds;
> +        __u64 es;
> +        __u64 orig_ax;
> +        __u64 ip;
> +        __u64 cs;
> +        __u64 flags;
> +        __u64 sp;
> +        __u64 ss;
> +        __u64 fs;
> +        __u64 gs;
> +
> +	__u64 debugreg0;
> +	__u64 debugreg1;
> +	__u64 debugreg2;
> +	__u64 debugreg3;
> +	__u64 debugreg6;
> +	__u64 debugreg7;
> +
> +	__u8 uses_debug;
> +
> +	__u8 used_math;
> +	__u8 has_fxsr;
> +	union thread_xstate xstate;	/* i387 */
> +};

It seems weird that you use __u64 members for the registers, but don't
include r8..r15 in the list. As a consequence, this structure does not
seem well suited for either x86-32 or x86-64.

I would suggest either using struct pt_regs by reference, or defining
it so that you can use the same structure for both 32 and 64 bit x86.

	Arnd <><
