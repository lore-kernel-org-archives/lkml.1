Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZKQI7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZKQI7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZKQI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:59:51 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:41841 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZKQI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:59:50 -0500
Date: Tue, 17 Nov 2009 09:59:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: tglx@linutronix.de, mingo@elte.hu,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix clock_gettime vsyscall time warp
Message-ID: <20091117095955.0df508a5@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1258436990.17765.83.camel@minggr.sh.intel.com>
References: <1258436990.17765.83.camel@minggr.sh.intel.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 13:49:50 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> The root cause is the NTP adjusted clock multiplier(timekeeper.mult) is
> not updated to vsyscall gtod data(vsyscall_gtod_data.clock.mult). 
> 
> Since commit 0a544198 "timekeeping: Move NTP adjusted clock multiplier
> to struct timekeeper", clock->mult is only the unmodified multiplier.
> 
> Below patch passes the adjusted clock multiplier to update_vsyscall.
> -void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
> +void update_vsyscall(struct timespec *wall_time, struct clocksource *clock, u32 mult)
> 
> With this patch applied to 2.6.32-rc7, I have been running
> time-warp-test for many hours without any time warp on both x86_64 and
> ia64 machines.
> 
> This patch also touches the powerpc code, so it would be very
> appreciated if anyone can help to test it on powerpc.

Ouch! Yes, good catch. That patch needs to go into 2.6.32.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

