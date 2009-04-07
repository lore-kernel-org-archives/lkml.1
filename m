Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbZDGW3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbZDGW3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbZDGW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:29:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27927 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZDGW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:29:19 -0400
X-IronPort-AV: E=Sophos;i="4.39,339,1235970000"; 
   d="scan'208";a="69212057"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Chris Peterson" <cpeterso@cpeterso.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Tue, 7 Apr 2009 18:30:37 -0400
User-Agent: KMail/1.9.5
CC: "Matt Mackall" <mpm@selenic.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <1239116251.14392.133.camel@calx> <a24804730904071439g4cc1779bi1ebaf814d370708c@mail.gmail.com>
In-Reply-To: <a24804730904071439g4cc1779bi1ebaf814d370708c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904071830.38081.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Apr 2009 22:28:18.0171 (UTC) FILETIME=[266084B0:01C9B7D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 7 Apr 2009 17:39, Chris Peterson pondered:
> 1. Are there any new add_*_randomness() functions that could be added?

I can think of - USB, serial, SDIO - but if any are heavily loaded with 
constant data - their randomness reduces, and becomes less useful. if it is 
the normal use case - then these might be better - but it is a function of 
the local users's use of the device - and is not remotely attackable.

> Some userspace daemons like EGD (running as root) feed random system
> info (e.g. vmstat) into /dev/random. But how many Linux distros
> actually run entropy-gathering daemons by default?

Not many that I can find.

> Would /dev/random 
> be more secure if entropy-gathering daemons were replaced with new
> kernel functions like add_vmstat_randomness() or add_ps_randomness()?

on embedded and server - it is likely most of ps (except load) will be pretty 
stable - even vmstat - might be on more stable than you think on embedded - 
which starts processes, allocates memory, and then just runs forever.....

> 2. Are there any other functions that could be calling the existing
> add_*_randomness() functions? Currently:
> 
> * add_input_randomness() is called from input_event().

Could be added in the serial core? usb? spi? i2c?

> * add_interrupt_randomess() is called from handle_IRQ_event() if
>    IRQF_SAMPLE_RANDOM is set.
> * add_disk_randomness() is called from blk_end_io() and __blk_end_request().
