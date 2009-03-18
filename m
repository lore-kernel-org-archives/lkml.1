Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZCRTgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZCRTgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZCRTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:35:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64840 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZCRTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FmBOVzbqCHVLVBwIiGrMkVx2PhXNdjAcMum68yBMIXWIezF3VferifFmHilxmM9r7K
         yeFbasiKPj0mleUFIV41VH01xRihIxhom1vrQ5Q7e4VSKrCW43k/kxFMaL/xD7Ls34qX
         6svKg2ZjjgXAFaRVyyE8/H6fglaex/yMAn7X8=
Date: Wed, 18 Mar 2009 20:35:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] tracing: fix oops in
	tracepoint_update_probe_range()
Message-ID: <20090318193546.GF5981@nowhere>
References: <1237394936.3132.1.camel@localhost.localdomain> <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org> <1237398997.22438.10.camel@ht.satnam> <20090318180007.GE5981@nowhere> <1237399930.22438.16.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237399930.22438.16.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 11:42:10PM +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-03-18 at 19:00 +0100, Frederic Weisbecker wrote:
> 
> > Jaswinder, It's hard for me to reproduce it via your config.
> > May be it's because I had to update it to match latest -tip tree and
> > then I inserted some noise inside.
> > 
> > Could you please send me your bad vmlinux, so that I can have a first look at
> > your elf sections and see if there is something helpful inside.
> > 
> 
> OK I am uploading vmlinux (file size 14729799) and dmesg on :
> 
> http://userweb.kernel.org/~jaswinder/oops_20090318/
> 
> Are you testing on 32 bit or 64 bit machine.
> 
> I am getting this error on 64 bit AMD box.
> 
> Thanks
> --
> JSR
> 

Actually I haven't tested but only looked at my elf sections and haven't
seen anything weird. (I run a 64 too).

Your sections are normal too:

$ objdump -t ./vmlinux | grep __tracepoint | sort -d

ffffffff81623b00 l     O __ksymtab_gpl	0000000000000010 __ksymtab___tracepoint_block_remap
ffffffff8162eeb3 l     O __ksymtab_strings	0000000000000019 __kstrtab___tracepoint_block_remap
ffffffff816fb800 g       .data	0000000000000000 __start___tracepoints
ffffffff816fb800 g     O .data	0000000000000020 __tracepoint_power_start
ffffffff816fb820 g     O .data	0000000000000020 __tracepoint_power_end
ffffffff816fb840 g     O .data	0000000000000020 __tracepoint_power_mark
ffffffff816fb860 g     O .data	0000000000000020 __tracepoint_sched_wait_task
ffffffff816fb880 g     O .data	0000000000000020 __tracepoint_sched_wakeup
ffffffff816fb8a0 g     O .data	0000000000000020 __tracepoint_sched_wakeup_new
ffffffff816fb8c0 g     O .data	0000000000000020 __tracepoint_sched_switch
ffffffff816fb8e0 g     O .data	0000000000000020 __tracepoint_sched_migrate_task
ffffffff816fb900 g     O .data	0000000000000020 __tracepoint_sched_process_fork
ffffffff816fb920 g     O .data	0000000000000020 __tracepoint_sched_process_free
ffffffff816fb940 g     O .data	0000000000000020 __tracepoint_sched_process_exit
ffffffff816fb960 g     O .data	0000000000000020 __tracepoint_sched_process_wait
ffffffff816fb980 g     O .data	0000000000000020 __tracepoint_softirq_entry
ffffffff816fb9a0 g     O .data	0000000000000020 __tracepoint_softirq_exit
ffffffff816fb9c0 g     O .data	0000000000000020 __tracepoint_sched_signal_send
ffffffff816fb9e0 g     O .data	0000000000000020 __tracepoint_workqueue_insertion
ffffffff816fba00 g     O .data	0000000000000020 __tracepoint_workqueue_execution
ffffffff816fba20 g     O .data	0000000000000020 __tracepoint_workqueue_creation
ffffffff816fba40 g     O .data	0000000000000020 __tracepoint_workqueue_destruction
ffffffff816fba60 g     O .data	0000000000000020 __tracepoint_sched_kthread_stop
ffffffff816fba80 g     O .data	0000000000000020 __tracepoint_sched_kthread_stop_ret
ffffffff816fbaa0 g     O .data	0000000000000020 __tracepoint_irq_handler_entry
ffffffff816fbac0 g     O .data	0000000000000020 __tracepoint_irq_handler_exit
ffffffff816fbae0 g     O .data	0000000000000020 __tracepoint_block_bio_bounce
ffffffff816fbb00 g     O .data	0000000000000020 __tracepoint_block_split
ffffffff816fbb20 g     O .data	0000000000000020 __tracepoint_block_rq_abort
ffffffff816fbb40 g     O .data	0000000000000020 __tracepoint_block_rq_insert
ffffffff816fbb60 g     O .data	0000000000000020 __tracepoint_block_rq_issue
ffffffff816fbb80 g     O .data	0000000000000020 __tracepoint_block_plug
ffffffff816fbba0 g     O .data	0000000000000020 __tracepoint_block_unplug_io
ffffffff816fbbc0 g     O .data	0000000000000020 __tracepoint_block_unplug_timer
ffffffff816fbbe0 g     O .data	0000000000000020 __tracepoint_block_getrq
ffffffff816fbc00 g     O .data	0000000000000020 __tracepoint_block_sleeprq
ffffffff816fbc20 g     O .data	0000000000000020 __tracepoint_block_rq_requeue
ffffffff816fbc40 g     O .data	0000000000000020 __tracepoint_block_bio_backmerge
ffffffff816fbc60 g     O .data	0000000000000020 __tracepoint_block_bio_frontmerge
ffffffff816fbc80 g     O .data	0000000000000020 __tracepoint_block_bio_queue
ffffffff816fbca0 g     O .data	0000000000000020 __tracepoint_block_rq_complete
ffffffff816fbcc0 g     O .data	0000000000000020 __tracepoint_block_remap
ffffffff816fbce0 g     O .data	0000000000000020 __tracepoint_block_bio_complete
ffffffff816fbd00 g       .data	0000000000000000 __stop___tracepoints

You see? __start___tracepoints and __stop___tracepoints embrace very well
a good number of tracepoints, so it's not empty.

You even have tracepoints for options that you haven't selected.
It seems that if CONFIG_TRACEPOINTS is enabled, all tracepoints that are found
in a built file will be configured.

And there are things such as workqueues that are always built in a kernel, so
the tracepoint section is _never_ supposed to be empty if CONFIG_TRACEPOINTS=y

Something screwed up somewhere...

