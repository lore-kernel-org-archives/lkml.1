Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZD2LcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZD2LcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZD2LcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:32:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZD2LcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:32:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 23/30] microblaze_mmu_v1: Enable fork syscall for MMU and add fork as vfork for noMMU
Date: Wed, 29 Apr 2009 13:31:26 +0200
User-Agent: KMail/1.9.9
Cc: John Williams <john.williams@petalogix.com>, linux-kernel@vger.kernel.org
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1d3f23370904270443u4ef547b3hab25b65babe329f3@mail.gmail.com> <49F82911.6060207@monstr.eu>
In-Reply-To: <49F82911.6060207@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904291331.27043.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Zfk70ru6oIbng6iZTZFwdMTfqK9mMNzftGyH
 WLTnqD7woWhF8GMPk/XY4YlnhH5TkxyGHmJPrElv8Bp1dyt1zk
 r6a7qG/XgR/ZUa6wL+MoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Michal Simek wrote:
> >> +sys_fork_wrapper:
> >>  sys_vfork_wrapper:
> >>        brid    sys_vfork
> >>        addk    r5, r1, r0
> > 
> > NACK!  If only it was that easy :)
> > 
> > On noMMU we cannot just silently call vfork() if the application tries
> > to fork() - you have to return -ENOSYS (or is there a better one?).
> > This will just require a small sys_fork_wrapper in entry-nommu.S.
> 
> I will call for noMMU kernel ni_syscall which solve that problem.
> (Arnd do it in his patches too)
> 

Note that my patches did not call the wrappers correctly, this
has to be fixed to make them work first.

For the fork call on !CONFIG_MMU, we should probably just add
a cond_syscall() in kernel/sys_ni.c near sys_msync() and
the other MMU specific calls.

	Arnd <><
