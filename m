Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967954Ab0B0ILH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:11:07 -0500
Received: from www.tglx.de ([62.245.132.106]:55511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967911Ab0B0ILG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:11:06 -0500
Date: Sat, 27 Feb 2010 09:10:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Carpenter <error27@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt2
In-Reply-To: <20100226194436.GE8417@bicker>
Message-ID: <alpine.LFD.2.00.1002270907470.4245@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <20100226194436.GE8417@bicker>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Dan Carpenter wrote:
> kernel/trace/latency_hist.c
>    341  static ssize_t
>    342  latency_hist_reset(struct file *file, const char __user *a,
>    343                     size_t size, loff_t *off)
>    344  {
>    345          int cpu;
>    346          struct hist_data *hist = NULL;
>    347  #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
>    348      defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
>    349          struct maxlatproc_data *mp = NULL;
>    350  #endif
>    351          off_t latency_type = (off_t) file->private_data;
>    352  
>    353          for_each_online_cpu(cpu) {
>    354  
>    355                  switch (latency_type) {
> 
> It seems like this switch statement should have a default case.
> 
> I haven't looked into it very closely but it seems like if you had all 
> those config options turned off then "hist" would be still be NULL.

When all config options are turned off then the file is not compiled
at all.

Thanks,

	tglx
