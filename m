Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157Ab0ARNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0ARNwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663Ab0ARNv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:51:59 -0500
Received: from www.tglx.de ([62.245.132.106]:49828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0ARNv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:51:59 -0500
Date: Mon, 18 Jan 2010 14:51:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <dfeng@redhat.com>
cc: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>, damm@igel.co.jp,
       hsweeten@visionengravers.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] clockevents: fix clockevent_devices list corruption
 after cpu hotplug
In-Reply-To: <4B53C7E0.1090201@redhat.com>
Message-ID: <alpine.LFD.2.00.1001181449220.2906@localhost.localdomain>
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain> <4B52D822.1010700@pardus.org.tr> <4B53C7E0.1090201@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-431561852-1263822678=:2906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-431561852-1263822678=:2906
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 18 Jan 2010, Xiaotian Feng wrote:

> On 01/17/2010 05:28 PM, Ozan Çağlayan wrote:
> > Thomas Gleixner wrote:
> > 
> > > 
> > > I'm not happy about that churn. Why don't we simply scan the
> > > clockevent_devices list for leftovers of the dead CPU ?
> > > 
> > > Untested patch below solves the same problem.
> > 
> > 
> > Hi, I have 3 bug reports about a clockevent failure while halting the system
> > (2.6.31.11 kernel).
> > It exactly pinpoints to the line 262 which got changed with this patch
> > merged to 2.6.31.10 (and also 2.6.32.3):
> > 
> > [4406.986777] kernel BUG at kernel/time/clockevents.c:262!
> > [4406.986777] invalid opcode: 0000 [#1] SMP
> > [4406.986777] last sysfs file: /sysfs/module/ip_tables/initstate
> 
> I think this one is duplicated of
> http://bugzilla.kernel.org/show_bug.cgi?id=15037
> Thomas is working on the fix. I've sent a workaround patch on
> http://patchwork.kernel.org/patch/71537/

I just applied your patch, but kept the cpuweight check. This is the
least intrusive solution for now. The logic needs an overhaul, but
thats neither rc4 nor stable material.

Thanks,

	tglx
--8323328-431561852-1263822678=:2906--
