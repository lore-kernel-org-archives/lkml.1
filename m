Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYDLTzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYDLTzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYDLTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:54:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbYDLTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:54:53 -0400
Date: Sat, 12 Apr 2008 12:49:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Erik Bosman <ebn310@few.vu.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <20080412124947.146865e4@laptopd505.fenrus.org>
In-Reply-To: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 18:55:58 +0200 (CEST)
Erik Bosman <ebn310@few.vu.nl> wrote:

> 
>     x86: Implement prctl PR_GET_TSC and PR_SET_TSC
> 
>     This patch adds a configure option CONFIG_DISABLE_TSC
>     (off by default) for the x86 platform to enable the
>     PR_GET_TSC and PR_SET_TSC commands. These control the
>     ability to use the timestamp counter from userspace
>     (the RDTSC instruction.)
> 
>     This patch uses code earlier used to disable the
>     timestamp counter for the SECCOMP framework. It used
>     to disable the RDTSC on 32 bit kernels, but allow it
>     on x86_64. This patch makes SECCOMP disable the
>     timestamp counter whenever CONFIG_DISABLE_TSC is
>     enabled.


Hi,

why did you make this a configuration option? In general it's not
a good idea to make userspace visible ABI's (PR_* clearly is one of these)
a CONFIG option unless there's some HUGE space saving going on.
I don't see that here....

So can you explain your rationale for making this a config option?

Greetings,
   Arjan van de Ven 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
