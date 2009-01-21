Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbZAUAYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbZAUAYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZAUAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:24:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZAUAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:24:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Date: Wed, 21 Jan 2009 01:24:25 +0100
User-Agent: KMail/1.9.9
Cc: jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.161626.93641145.davem@davemloft.net>
In-Reply-To: <20090120.161626.93641145.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210124.26118.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18w2AMSzUMT7Q5G9YDW6ortaOEvOtDcWIRaqpw
 xwVs6wCWZfL5sHKatOKWYmVE6T+jk2TTQEF854q6r25tNo4EpU
 MUdE/IONDkOX3GuOrZ1hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, David Miller wrote:
> From: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Date: Wed, 21 Jan 2009 05:34:17 +0530
> 
> > usr/include/asm-generic/fcntl.h is giving 2 'make headers_check' warnings:
> >  usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
> >  usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid
> > 
> > usr/include/asm-generic/fcntl.h:
> ...
> > #ifndef CONFIG_64BIT will always be true for userspace. So what is the use of #ifndef CONFIG_64BIT ?
> 
> Good catch.
> 
> This file needs to test for 64-bit'ness using some non-CONFIG_*
> test.  And the standard built-in CPP macros which can be used
> to check for that are different on every platform.

I think we should simply define a macro for use in the kernel, e.g. in
<asm/types.h>. There already is a BITS_PER_LONG macro in there, maybe
we can add an exported __BITS_PER_LONG there that checks for the right
macro on each architecture.

On parisc, there is a major confusion in this area, at some point, all
checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
not understood what the problem with __LP64__ was, the check for
CONFIG_64BIT on parisc user space looks very wrong.

	Arnd <><
