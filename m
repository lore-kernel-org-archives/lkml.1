Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743Ab0AHJLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0AHJLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116Ab0AHJLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:11:42 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11044 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0AHJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:11:42 -0500
X-IronPort-AV: E=Sophos;i="4.49,241,1262581200"; 
   d="scan'208";a="11291510"
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
From: Li Yi <yi.li@analog.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <20100108051847.GB5468@nowhere>
References: <1262925925.27700.15.camel@adam-desktop>
	 <20100108051847.GB5468@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 8 Jan 2010 17:13:15 +0800
Message-ID: <1262941995.27700.282.camel@adam-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2010 09:11:36.0357 (UTC) FILETIME=[94498D50:01CA9042]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 06:18 +0100, Frederic Weisbecker wrote:
> On Fri, Jan 08, 2010 at 12:45:25PM +0800, Li Yi wrote:
> > "irqsoff" tracer may cause stack overflow on architectures using
> > asm-generic/atomic.h, due to recursive invoking of, e.g.
> > trace_hardirqs_off().
> > 
> > trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() ->
> > atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()
> > 
> > Signed-off-by: Yi Li <yi.li@analog.com>
> 
> 
> 
> Good catch!
> 
> However, may be we should keep the local_irq_save there
> and have __raw_atomic_* versions only for tracing.
> 
> It's better to keep track of most irq disabled sites.
> 
> Why not something like the following (untested):
Yes. I agree this is better solution.

-Yi

