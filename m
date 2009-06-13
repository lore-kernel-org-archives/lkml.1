Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZFMWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZFMWXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZFMWXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:23:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZFMWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:23:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 07/27] score: create head files elf.h emergency-restart.h errno.h
Date: Sun, 14 Jun 2009 00:23:06 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OF33B57F6A.69479DBB-ON482575D4.00247552-482575D4.002503BB@sunplusct.com>
In-Reply-To: <OF33B57F6A.69479DBB-ON482575D4.00247552-482575D4.002503BB@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200906140023.06690.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+hTmGiXlz9IJTx+x7DmZycjB2X5tNNcizR8ZT
 sWIM4ohbXxwDgBLM5QEjLgi03m8+df7vHhhb1j2vS8PkdLp4VY
 GoufKtJZ34epqXnjJ/KkrtXA0RnhGZ4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, liqin.chen@sunplusct.com wrote:
> > 
> > EMAXERRNO is mips specific right now. Do you actually need it somewhere?
> > 
> 
> Yes, I used it in entry.S, maybe I could remove this define latter.
> 

Ok. Note that the maximum error number that is supposed to get sent back
to user space is 511. Most architectures check the return value of the
system call to be between -4095 and zero upon entering user space.
Checking it in the kernel gives you the chance to override the
error status from a system call with force_successful_syscall_return().

If that is your intention, you should probably leave the definition in there.
Powerpc uses _LAST_ERRNO for the same purpose, which is somewhat inconsistent
with mips and also uses a different value to compare against.

	Arnd <><
