Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYDWPAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYDWPAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYDWPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:00:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYDWPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:00:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Date: Wed, 23 Apr 2008 16:59:24 +0200
User-Agent: KMail/1.9.9
Cc: "Kyle McMartin" <kyle@mcmartin.ca>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422153849.GH19802@phobos.i.cabal.ca> <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
In-Reply-To: <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231659.24463.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+jfl3i1cv/0BBZCUcUVytz1jwzQpUAbRM9Geq
 N9p6d6IOzkWc1RQjMtKFMQWlbRAKjDypJBPhRQ9f+ztT2/S+ZT
 19zplSW/7ubQ6G5O1BYBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Will Newton wrote:
> I implemented the approach you suggested - Kconfig symbol and
> cond_syscall definition. I think I actually like the previous approach
> better:
> 
> 1. The arch Kconfig files are quite non-uniform compared to unistd.h
> so the definitions wind up at different places in the file which is a
> bit messy.
> 2. Changes to Kconfig may cause churn in defconfigs perhaps?
> 3. There is more churn in arch Kconfig than unistd.h so getting a
> cross arch patch applied is likely to be more difficult.
> 4. The patch is about 4 times as many lines.
> 
> What do you think?

I still feel that the original patch was more helpful and consistent
with how we do it for the existing obsolete syscalls.

Note that there is a much simpler solution if you just use an
"#ifdef __NR_sys_sysfs" around the definition of the syscall, but
that has another disadvantage in that it is harder to spot when
new architectures get it wrong.

	Arnd <><
