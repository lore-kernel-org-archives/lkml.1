Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623Ab0ALQ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0ALQ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566Ab0ALQ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:27:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab0ALQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:27:27 -0500
Date: Tue, 12 Jan 2010 08:26:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Valdis.Kletnieks@vt.edu
cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
In-Reply-To: <6686.1263312874@localhost>
Message-ID: <alpine.LFD.2.00.1001120823120.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-4-git-send-email-yinghai@kernel.org>            <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain> <6686.1263312874@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, Valdis.Kletnieks@vt.edu wrote:
> 
> OK, I'll bite - how do you build an X86-64 kernel that doesn't have
> CONFIG_HOTPLUG_CPU selected?  Try as I might, even if I have PM_SLEEP=n,
> PM_SLEEP_SMP insists on being set, and then selecting HOTPLUG_SMP.

If that is true, then there is some bug in the kconfig parser. 
PM_SLEEP_SMP depends on PM_SLEEP, so with PM_SLEEP=n it should never be 
set.

That said, regardless of any such problems, I do think that we should 
think about splitting up HOTPLUG_CPU into two config options: one that 
allows CPU's to be put to sleep (which is common, and needed for any 
suspend/hibernate support), and one that actually has support for actual 
physical hotplugging.

				Linus
