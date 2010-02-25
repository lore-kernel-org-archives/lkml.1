Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178Ab0BYVn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:43:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158Ab0BYVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:55 -0500
Subject: Re: [PATCH 3/3] sched: make runtime balancing code more
 EDF-friendly
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <61a4579f9c15818ee9c878d21b9db90480f16261.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <61a4579f9c15818ee9c878d21b9db90480f16261.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:26 +0100
Message-ID: <1267129706.22519.562.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> +               stop = move_runtime(rt_rq, iter, weight, rt_period,
> pull);
> +               if (stop) {
> +                       raw_spin_unlock(&iter->rt_runtime_lock);
> +                       break;
>                 }
>  next:
>                 raw_spin_unlock(&iter->rt_runtime_lock); 

might as well put that:

  if (stop)
    break;

right after the raw_spin_unlock() that's already there.

