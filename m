Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYHGNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYHGNI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYHGNII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:08:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16491 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbYHGNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:08:05 -0400
Date: Thu, 7 Aug 2008 15:07:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kyuma Ohta <whatisthis.sowhat@gmail.com>,
       ivtv-devel ML <ivtv-devel@ivtvdriver.org>,
       Video4Linux ML <video4linux-list@redhat.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU CX23416-STVLP
Message-ID: <20080807150738.5b1dde60@hyperion.delvare>
In-Reply-To: <200808032312.25222.hverkuil@xs4all.nl>
References: <1216308014.1146.22.camel@melchior>
	<200807171758.19702.hverkuil@xs4all.nl>
	<1216336451.1146.41.camel@melchior>
	<200808032312.25222.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sun, 3 Aug 2008 23:12:25 +0200, Hans Verkuil wrote:
> Hi Ohta,
> 
> Well, I picked up my card this weekend and tested it. It turns out to be 
> an i2c-core.c bug: chips with i2c addresses in the 0x5x range are 
> probed differently than other chips and the probe command contains an 
> error. The upd64083 has an address in that range and so was hit by this 
> bug. The attached patch for linux/drivers/i2c/i2c-core.c will fix it.
> 
> As you can see, this mail also goes to Jean Delvare so that he can move 
> this upstream (should also go to the 2.6.26-stable series, Jean!).
> 
> For the ivtv driver this bug will only hit cards where ivtv has to probe 
> for an upd64083.
> 
> SoB for this patch:
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> I've verified that this is only an issue with kernels 2.6.26 and up. 
> Older kernels are not affected unless the ivtv driver from the v4l-dvb 
> repository is used. To be more precise: this bug has been in i2c-core.c 
> since 2.6.22, but the ivtv driver in 2.6.26 was the first driver that 
> used i2c_new_probed_device() with an i2c address in a range that caused 
> the broken probe to be used.

Good catch, thanks for the patch. I'll push it to Linus by the end of
the week.

-- 
Jean Delvare
