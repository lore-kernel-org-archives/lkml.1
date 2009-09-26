Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZIZTfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZIZTfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZIZTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:35:48 -0400
Received: from mail-yx0-f165.google.com ([209.85.210.165]:63363 "EHLO
	mail-yx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZIZTfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:35:43 -0400
MIME-Version: 1.0
Date: Sat, 26 Sep 2009 12:35:47 -0700 (PDT)
In-Reply-To: <dkXAT-6SV-9@gated-at.bofh.it>
X-IP: 86.25.244.65
References: <dkAXF-4Gg-25@gated-at.bofh.it> <dkHFQ-1FQ-3@gated-at.bofh.it> 
	<dkNrM-6Fq-11@gated-at.bofh.it> <dkX7N-6wO-15@gated-at.bofh.it> 
	<dkXAT-6SV-9@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 home (squid/3.0.STABLE8)
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) 
	Gecko/20090924 Ubuntu/9.10 (karmic) Firefox/3.5.3,gzip(gfe),gzip(gfe)
Message-ID: <d6d20154-ed2d-492e-9ae1-d9b6b74d91cd@s6g2000vbp.googlegroups.com>
Subject: Re: unfair io behaviour for high load interactive use still present 
	in 2.6.31
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 16, 9:00 am, Tobias Oetiker <t...@oetiker.ch> wrote:
> Today Corrado Zoccolo wrote:
> > On Tue, Sep 15, 2009 at 11:07 PM, Tobias Oetiker <t...@oetiker.ch> wrote:
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > ---------------------------------------------------------------------------------------------------------
> > > dm-18             0.00     0.00    0.00 2566.80     0.00    10.03     8.00  2224.74  737.62   0.39 100.00
> > > dm-18             0.00     0.00    9.60  679.00     0.04     2.65     8.00   400.41 1029.73   1.35  92.80
> > > dm-18             0.00     0.00    0.00 2080.80     0.00     8.13     8.00   906.58  456.45   0.48 100.00
> > > dm-18             0.00     0.00    0.00 2349.20     0.00     9.18     8.00  1351.17  491.44   0.43 100.00
> > > dm-18             0.00     0.00    3.80  665.60     0.01     2.60     8.00   906.72 1098.75   1.39  93.20
> > > dm-18             0.00     0.00    0.00 1811.20     0.00     7.07     8.00  1008.23  725.34   0.55 100.00
> > > dm-18             0.00     0.00    0.00 2632.60     0.00    10.28     8.00  1651.18  640.61   0.38 100.00
>
> > Good.
> > The high await is normal for writes, especially since you get so many
> > queued requests.
> > can you post the output of "grep -r .  /sys/block/_device_/queue/" and
> > iostat for your real devices?
> > This should not affect reads, that will preempt writes with cfq.
>
> /sys/block/sdc/queue/nr_requests:128
> /sys/block/sdc/queue/read_ahead_kb:128
> /sys/block/sdc/queue/max_hw_sectors_kb:2048
> /sys/block/sdc/queue/max_sectors_kb:512
> /sys/block/sdc/queue/scheduler:noop anticipatory deadline [cfq]
> /sys/block/sdc/queue/hw_sector_size:512
> /sys/block/sdc/queue/logical_block_size:512
> /sys/block/sdc/queue/physical_block_size:512
> /sys/block/sdc/queue/minimum_io_size:512
> /sys/block/sdc/queue/optimal_io_size:0
> /sys/block/sdc/queue/rotational:1
> /sys/block/sdc/queue/nomerges:0
> /sys/block/sdc/queue/rq_affinity:0
> /sys/block/sdc/queue/iostats:1

> /sys/block/sdc/queue/iosched/quantum:4

As Mike points out [1], it may be worth trying a small quantum, though
the benefit may depend on the behaviour of your SCSI RAID controller.

--- [1]

http://groups.google.com/group/linux.kernel/browse_thread/thread/49d2360a22af8898/60022a7e287af096#60022a7e287af096
--
Daniel J Blueman
