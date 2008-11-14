Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYKNS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYKNS53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYKNS5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:57:21 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:33163 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYKNS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:57:20 -0500
Subject: Re: [alsa-devel] 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang
	(tasklet_hi_schedule?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <491D33B9.5030308@ladisch.de>
References: <1226019485.3135.31.camel@localhost.localdomain>
	 <49140683.9040008@ladisch.de>
	 <1226610075.23485.20.camel@localhost.localdomain>
	 <1226616962.23485.28.camel@localhost.localdomain>
	 <1226621569.23485.44.camel@localhost.localdomain>
	 <491D33B9.5030308@ladisch.de>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 10:57:10 -0800
Message-Id: <1226689030.17495.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 09:15 +0100, Clemens Ladisch wrote:
> Fernando Lopez-Lezcano wrote:
> > I've been trying to follow the printk crumbs without much success.
> > AFAICT it all points to tasklet_hi_schedule ...
> 
> I don't have -rt, but if the error is similar to the old one you might
> try replacing tasklet_hi_schedule with tasklet_schedule.

YES YES!! __Thanks__ for the suggestion, it WORKED!!

Maybe the kernel rt gurus should look around and see _why_ the problem
was happening in the first place. There are not that many uses of
tasklet_hi_schedule in the kernel tree I'm working with:

./drivers/char/drm/drm_irq.c
./drivers/infiniband/hw/ehca/ehca_irq.c
./drivers/infiniband/hw/ipath/ipath_cq.c
./drivers/infiniband/hw/ipath/ipath_driver.c
./drivers/infiniband/hw/ipath/ipath_intr.c
./drivers/infiniband/hw/ipath/ipath_sdma.c
./drivers/media/video/vino.c
./drivers/mmc/host/omap.c
./drivers/mmc/host/wbsd.c
./drivers/net/chelsio/sge.c
./drivers/net/ehea/ehea_main.c
./drivers/net/smc91x.c
./drivers/s390/block/dasd.c
./drivers/s390/cio/qdio.c
./drivers/s390/net/ctcm_fsms.c
./drivers/s390/net/ctcm_mpc.c
./drivers/usb/c67x00/c67x00-sched.c
./drivers/usb/gadget/gmidi.c
./kernel/softirq.c
./sound/core/rtctimer.c
./sound/core/timer.c
./sound/drivers/vx/vx_core.c
./sound/drivers/vx/vx_pcm.c
./sound/pci/es1968.c
./sound/pci/maestro3.c
./sound/pci/mixart/mixart_core.c
./sound/pci/pcxhr/pcxhr.c
./sound/pci/pcxhr/pcxhr_core.c
./sound/pci/riptide/riptide.c
./sound/pci/rme9652/hdsp.c
./sound/pci/rme9652/hdspm.c
./sound/pcmcia/pdaudiocf/pdaudiocf_irq.c
./sound/usb/usbmidi.c

Maybe other drivers are affected as well by the rt patch. 
What is the difference between tasklet_hi_schedule and tasklet_schedule?

Thanks again...
-- Fernando


