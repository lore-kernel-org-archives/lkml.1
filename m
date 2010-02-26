Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965914Ab0BZTow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:44:52 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43020 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965843Ab0BZTou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:44:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GYQN/RpB/bY1zOChzBkG9pfXwFF1ptd2PzMxvbIld1vjrYKcKYTwqoL73Hdj5haFtI
         UPWP/I7J77YdAxaw108HoFVngakoWfX0RoY3coExahrbQaiI6V5zmrC1z+cHNb72jLOU
         u7Y1zJeQIjfQvlZ8j3eqFRkaIMalPbX0nxT2o=
Date: Fri, 26 Feb 2010 22:44:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt2
Message-ID: <20100226194436.GE8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	rt-users <linux-rt-users@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
	Carsten Emde <ce@ceag.ch>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/latency_hist.c
   341  static ssize_t
   342  latency_hist_reset(struct file *file, const char __user *a,
   343                     size_t size, loff_t *off)
   344  {
   345          int cpu;
   346          struct hist_data *hist = NULL;
   347  #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
   348      defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
   349          struct maxlatproc_data *mp = NULL;
   350  #endif
   351          off_t latency_type = (off_t) file->private_data;
   352  
   353          for_each_online_cpu(cpu) {
   354  
   355                  switch (latency_type) {

It seems like this switch statement should have a default case.

I haven't looked into it very closely but it seems like if you had all 
those config options turned off then "hist" would be still be NULL.

regards,
dan carpenter


