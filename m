Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbZHGLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbZHGLpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZHGLpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:45:43 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:57218 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZHGLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:45:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, oleg@redhat.com
In-Reply-To: <20090807092256.A6083@sedona.ch.intel.com>
References: <20090807092256.A6083@sedona.ch.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 13:45:24 +0200
Message-Id: <1249645524.32113.688.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 09:22 +0200, Markus Metzger wrote:
> @@ -721,9 +903,13 @@ static int __hw_perf_counter_init(struct
>         err = 0;
>         if (!atomic_inc_not_zero(&active_counters)) {
>                 mutex_lock(&pmc_reserve_mutex);
> -               if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
> -                       err = -EBUSY;
> -               else
> +               if (atomic_read(&active_counters) == 0) {
> +                       if (!reserve_pmc_hardware())
> +                               err = -EBUSY;
> +                       else
> +                               reserve_bts_hardware();
> +               }
> +               if (!err)
>                         atomic_inc(&active_counters);
>                 mutex_unlock(&pmc_reserve_mutex);
>         }

You loose the reserve_bts_hardware() error case there.

