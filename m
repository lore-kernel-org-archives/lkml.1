Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZHOJFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZHOJFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZHOJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:05:04 -0400
Received: from www.tglx.de ([62.245.132.106]:44192 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZHOJE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:04:59 -0400
Date: Sat, 15 Aug 2009 11:04:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>
Subject: Re: [patch 10/15] add xtime_shift and ntp_error_shift to struct
 timekeeper
In-Reply-To: <20090814134809.871899606@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0908151102300.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com> <20090814134809.871899606@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Martin Schwidefsky wrote:
>  		timekeeper.xtime_nsec += timekeeper.xtime_interval;
> -		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
> -			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
> +		nsecs = (u64) NSEC_PER_SEC << timekeeper.shift;

Minor nit. I made this a separate u64 variable as nsecs is s64 and
while this signed/unsigned mismatch is probably not hurting in that
context it's still not pretty :)

Thanks,

	tglx
