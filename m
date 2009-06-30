Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZF3Vmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZF3Vmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZF3Vma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:42:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZF3Vm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:42:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] FRV: Wire up new syscalls
Date: Tue, 30 Jun 2009 23:41:58 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu>
In-Reply-To: <20090630213406.GB17492@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906302341.58582.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ezHrrtgFUt5X08nqgR6zetWP9K+jCsz7y4cE
 yqHI9lVVlFTNOkDjXME1usXGebcdtremyEajaMaZyBMZw0/Nry
 cjCWpJQp7HhufoVQ0cinw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Ingo Molnar wrote:
> * David Howells <dhowells@redhat.com> wrote:
> 
> > Wire up new syscalls rt_tgsigqueueinfo and perf_counter_open.
> 
> > +     .long sys_perf_counter_open
> 
> Hm, i suspect this should be sys_ni because FRV does not set 
> HAVE_PERF_COUNTERS so perfcounters cannot be enabled. (Or do you 
> have patches in the pipeline that enable perfcounters for FRV?)

It doesn't matter because of the cond_syscall() in kernel/sys_ni.c.
Right now, scripts/checksyscalls.sh causes a warning on each architecture
that does not assign a system call number for sys_perf_counter_open,
so they might as well make it point to sys_ni though cond_syscall().

	Arnd <><
