Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZDGLOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZDGLOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZDGLOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:14:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:59066 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZDGLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:14:11 -0400
X-IronPort-AV: E=Sophos;i="4.39,337,1235970000"; 
   d="scan'208";a="69177913"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Tue, 7 Apr 2009 07:16:25 -0400
User-Agent: KMail/1.9.5
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Chris Peterson" <cpeterso@cpeterso.com>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <1239044483.14392.55.camel@calx>
In-Reply-To: <1239044483.14392.55.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904070716.25846.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Apr 2009 11:14:08.0356 (UTC) FILETIME=[F8689240:01C9B771]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 6 Apr 2009 15:01, Matt Mackall pondered:
> On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
> > We have lots of embedded headless systems (no keyboard/mouse, no
> > soundcard, no video) systems with *no* sources of entropy - and
> > people using SSL. 
> 
> I'd rather add a random_sample_network call somewhere reasonably central
> in the network stack. Then we can use the knowledge that the sample is
> network-connected in the random core to decide how to measure its
> entropy. The trouble with IRQF_SAMPLE_RANDOM is that many of its users
> are technically bogus as entropy sources in the current model.

OK - that makes more sense.

Does that mean we also shouldn't be using IRQF_SAMPLE_RANDOM on interrupt 
sources in subsystems which already have add_xxx_randomness() in them? (block 
devices, and input devices?)

block/blk-core.c -> blk_end_io() -> add_disk_randomness()
drivers/input/input.c -> input_event() -> add_input_randomness()

 drivers/block/xen-blkfront.c, line 639

 drivers/input/touchscreen/wm97xx-core.c, line 374
 drivers/input/keyboard/gpio_keys.c, line 145
 drivers/input/keyboard/bf54x-keys.c, line 255
 drivers/input/serio/hp_sdc.c, line 881

> I'm eventually going to move the RNG away from the strict theoretical
> entropy accounting model to a more pragmatic one which will be much
> happier with iffy entropy sources, but that's a ways off.

Looking forward to it.
