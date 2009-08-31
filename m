Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbZHaOAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbZHaOAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZHaOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:00:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:15505 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZHaOAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:00:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182351935"
Date: Mon, 31 Aug 2009 22:00:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090831140006.GA23668@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com> <20090712080410.GA8512@localhost> <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com> <20090829101247.GA20786@localhost> <20090829102126.GA22409@localhost> <6afc6d4a0908310624j47f9d8c7h47d98ecd95811883@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6afc6d4a0908310624j47f9d8c7h47d98ecd95811883@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

What's your SSD's IO parameters? Ie. output of this command:

        grep -r . /sys/block/sda/queue/        

Please replace 'sda' with your SSD device name.

Thanks,
Fengguang

On Mon, Aug 31, 2009 at 09:24:20PM +0800, Fernando Silveira wrote:
> On Sat, Aug 29, 2009 at 07:21, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Sat, Aug 29, 2009 at 06:12:47PM +0800, Wu Fengguang wrote:
> >> On Sat, Aug 29, 2009 at 05:48:40AM +0800, Fernando Silveira wrote:
> >> > On Sun, Jul 12, 2009 at 05:04, Wu Fengguang<fengguang.wu@intel.com> wrote:
> >> > > On Sat, Jul 11, 2009 at 02:27:25PM -0300, Fernando Silveira wrote:
> >> > >> I'm having a hard time with an application that writes sequentially
> >> > >> 250GB of non-stop data directly to a solid state disk (OCZ SSD CORE
> >> > >> v2) device and I hope you can help me. The command "dd if=/dev/zero
> >> > >> of=/dev/sdc bs=4M" reproduces the same symptoms I'm having and writes
> >> > >> exactly as that application does.
> >>
> >> Sure. Attached is a writeback debug patch. It will generate lots of
> >> kernel messages. You can just stop your klogd, start your workload
> >> and monitor the SSD writeback throughput via tools like iostat/dstat.
> >
> > Fernando, will you post the output of iostat/dstat too? Thanks!
> > The ssd-no_dirty_buffer_with_random_192mb_writes.png is a good overview,
> > however I'd like to also check out the numbers for each second :)
> >
> >> When it goes into the suboptimal 25MB/s state for several seconds, run
> >>         dmesg > dmesg-writeback
> >> and send me the log.
> >>
> >> And it is advised to turn on the kconfig option CONFIG_PRINTK_TIME=y.
> 
> Thanks for your help.
> 
> You can reach in the URL below a tarball which contains the data I
> logged after patching the kernel with only your last patch.
> 
> http://rootshell.be/~swrh/ssd-tests/log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M.tar.gz
> 
> Each file contained in the tarball is described below:
> 
> - log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M-{0-ddv,1-table,2-plot}.*
>   Logging statistics. The "0-ddv" file is the log of a modified
> version of the dd(1) utility to print writing statistics after every
> write(2), "1-table" is a table version of the "0-ddv" file parsed with
> awk(1) and "2-plot" is the a plot image of the writing statistics.
> 
> - log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M-0-dstat.log
>   The result of "dstat > dstat.log" executed ~3 seconds after "ddv" started.
> 
> - log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M-0-iostat.log
>   The result of "iostat 1 > iostat.log" executed ~15 seconds after
> "ddv" started.
> 
> - log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M-0-dmesg_writeback_{1..67}.log
>   The result of "for i in {1..67}; do dmesg > dmesg-writeback-$i.log;
> sleep 1; done" executed when "ddv" had written about 42GB of data.
> 
> - log-20090831_0908-MK020903042C0001B-prosar_fcc2-bs_4M-0-dmesg_writeback_{100..186}.log
>   The result of "for i in {100..186}; do dmesg >
> dmesg-writeback-$i.log; sleep 1; done" executed when "ddv" had written
> about 51GB of data.
> 
> Please tell me if you need anything else. I could make a more
> synchronized or informative logging output if you need.
> 
> Best regards,
> 
> -- 
> Fernando Silveira <fsilveira@gmail.com>
