Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZBDAfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZBDAfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZBDAez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:34:55 -0500
Received: from mx2.netapp.com ([216.240.18.37]:33449 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZBDAey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:34:54 -0500
X-IronPort-AV: E=Sophos;i="4.37,375,1231142400"; 
   d="scan'208";a="122564281"
Subject: Re: [patch] remove put_cpu_no_resched()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>
In-Reply-To: <20090204001840.664546943@linutronix.de>
References: <20090204001840.664546943@linutronix.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 03 Feb 2009 19:33:59 -0500
Message-Id: <1233707639.7161.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
X-OriginalArrivalTime: 04 Feb 2009 00:34:46.0088 (UTC) FILETIME=[611A8480:01C98660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 00:27 +0000, Thomas Gleixner wrote:
> plain text document attachment (remove-put-cpu-no-resched.patch)
> Impact: remove a high latency source
> 
> put_cpu_no_resched() is an optimization of put_cpu() which
> unfortunately can cause high latencies.
> 
> The nfs iostats code uses put_cpu_no_resched() in a code sequence
> where a reschedule request caused by an interrupt between the
> get_cpu() and the put_cpu_no_resched() can delay the reschedule for at
> least HZ.
> 
> The other users of put_cpu_no_resched() optimize correctly in
> interrupt code, but there is no real harm in using the put_cpu()
> function which is an alias for preempt_enable(). The extra check of the
> preemmpt count is not as critical as the potential source of missing a
> reschedule.
> 
> Debugged in the preempt-rt tree and verified in mainline.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
