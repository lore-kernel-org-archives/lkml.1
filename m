Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbXHUQ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbXHUQ3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbXHUQ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:29:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17268 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbXHUQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:29:32 -0400
Subject: Re: [PATCH] [12/58] x86_64: Add vDSO for x86-64 with
	gettimeofday/clock_gettime/getcpu
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070719095456.B996214E03@wotan.suse.de>
References: <200707191154.642492000@suse.de>
	 <20070719095456.B996214E03@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 09:25:01 -0700
Message-Id: <1187713502.7732.65.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 11:54 +0200, Andi Kleen wrote:
> +
> +static noinline int do_realtime(struct timespec *ts)
> +{
> +       unsigned long seq, ns;
> +       do {
> +               seq = read_seqbegin(&gtod->lock);
> +               ts->tv_sec = gtod->wall_time_sec;
> +               ts->tv_nsec = gtod->wall_time_nsec;
> +               ns = vgetns();
> +       } while (unlikely(read_seqretry(&gtod->lock, seq)));
> +       timespec_add_ns(ts, ns);
> +       return 0;
> +} 

Some thoughts ,

In the -mm kernel there is some debugging that gets injected into the
likely/unlikely macros .. If they get called from userspace it causes a
hang .. We might want to add some new set of macros to specifically
denote that they are called from userspace, not just likely/unlikely but
all the macros so we don't get mixed usage ..

Daniel

