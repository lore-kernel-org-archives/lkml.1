Return-Path: <linux-kernel-owner+w=401wt.eu-S1763876AbZD3Nwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763876AbZD3Nwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbZD3NwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:52:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763723AbZD3NwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:52:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: Memory limits - mm_segment_t - MAKE_MM_SEG
Date: Thu, 30 Apr 2009 15:50:34 +0200
User-Agent: KMail/1.9.9
Cc: John Williams <john.williams@petalogix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <49F85C27.9000308@monstr.eu>
In-Reply-To: <49F85C27.9000308@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301550.35112.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DTse/9qLTirLybmt8cTKhyZFSKy2mb7fMase
 usY1ZD4cQPJeFiSCZGfmdcnp6pU5NUF1P6LwZymVFRP5G2l8lE
 VIL8gqPuCroUfXCuIa4KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Michal Simek wrote:
> I look at some things which I need to clear for MMU Microblaze patches and
> I would like to know your opinion about.
> 
> First of all I found that almost all archs use MAKE_MM_SEG macro which 
> should be good to move to generic location (asm-generic/uaccess.h ? )
> #define MAKE_MM_SEG(s) ((mm_segment_t) { (s) })

I have a generic uaccess.h queued up, which I'm planning to submit for
2.6.30 that includes this. 

> The second thing is about place where is stored limit for processes -> mm_segment_t structure
> 
> Where is the proper location for storing mm_segment_t? Some arch use
> thread_info some of them thread_struct

The method that is used here is different on some architectures.
Most of them use the address limit, which is a property of the
thread, and sensibly belongs into the thread_info. s390 and possibly
others have separate address spaces for user access and use a CPU
feature for this, which belongs into thread_struct.

> Here is the small table for cpus which are in linux kernel and location and type for them.
> The most of them uses thread_info structure for it and name is addr_limit.
> The location of mm_segment_t is different too -> we should move it to any generic location too.
> What do you think?

Sounds fair to me. I think uaccess.h is the best place for this, or maybe
a new mm_segment.h, but not segment.h which is used traditionally for
real segments on x86.

	Arnd <><
