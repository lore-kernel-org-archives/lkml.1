Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZBZMlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZBZMlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZBZMl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:41:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZBZMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:41:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Date: Thu, 26 Feb 2009 13:40:56 +0100
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com> <1235650806.4948.71.camel@laptop> <20090226122623.GC23099@elte.hu>
In-Reply-To: <20090226122623.GC23099@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261340.57353.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+5jyXfnbcIcA9k14G7g9+PVww2dVtF/m3pUa1
 l6W9alOFSnjcNzCuK8IDsfGBCEajFCSQ3DAXmRs1gpzlND7sWM
 2Uvr90Uxv+Ciup8VA4npA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Ingo Molnar wrote:
>
> > Yeah, atomic64_t has been proposed numerous times, and x86 
> > could actually implement that using cmpxchg8b, just not sure 
> > about all the other 32bit archs, and if we start using it in 
> > the scheduler, they'd better have it implemented.
> 
> I have written a working atomic64_t implementation for 
> tip:perfcounters/core, for 32-bit x86.

It should also be possible to write an asm-generic atomic64_t
implementation based on the parisc atomic_t hashlock code.
For non-SMP configurations, it falls back on local_irq_save(),
which is already the method used for atomic_t on half the
embedded architectures.

	Arnd <><
