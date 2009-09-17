Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZIQTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZIQTe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZIQTe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:34:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZIQTe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:34:26 -0400
Date: Thu, 17 Sep 2009 21:34:09 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de
Subject: Re: [tip:perfcounters/core] perf sched: Determine the number of
 CPUs automatically
Message-ID: <20090917213409.39b8509c@infradead.org>
In-Reply-To: <tip-5349256ab12dcbc766495cd1cf3651f7203f8564@git.kernel.org>
References: <new-submission>
	<tip-5349256ab12dcbc766495cd1cf3651f7203f8564@git.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 18:07:09 GMT
> 
> perf sched: Determine the number of CPUs automatically
> 
> For 'perf sched map' output, determine max_cpu automatically,
> instead of the static default of 15.
>  
>  static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
>  
> @@ -1818,6 +1818,9 @@ static struct trace_sched_handler map_ops  = {
>  
>  static void __cmd_map(void)
>  {
> +	max_cpu = system("exit `grep ^processor /proc/cpuinfo  | wc
> -l`");

YUCK.

what is wrong with
   max_cpu = sysconf(_SC_NPROCESSORS_CONF); 
??

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
