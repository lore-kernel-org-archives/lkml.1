Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYKKIq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYKKIq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYKKIqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:46:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbYKKIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:46:47 -0500
Date: Tue, 11 Nov 2008 00:46:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: arrow.ebd@gmail.com
Cc: linux_kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: thinkpad x200 X.server not work with gm4500 graphics
Message-Id: <20081111004643.8f8608a3.akpm@linux-foundation.org>
In-Reply-To: <20081110152518.GA3545@think>
References: <20081110152518.GA3545@think>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 23:25:18 +0800 arrow.ebd@gmail.com wrote:

> deal,
> 
>     My thinkpad x200's X.server can not startup on the kernel 2.6.28,

Were any earlier kernels OK?  If so, which version(s)?

Thanks.

> and dmesg will show as below:
>     -->>--
>     [drm] Initialized drm 1.1.0 20060810
>     pci 0000:00:02.0: power state changed by ACPI to D0
>     pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>     pci 0000:00:02.0: setting latency timer to 64
>     [drm] Initialized i915 1.6.0 20060119 on minor 0
>     pci 0000:00:02.0: pg_start == 0x00001f7f, intel_private.gtt_entries == 0x00001fff
>     pci 0000:00:02.0: trying to insert into local/stolen memory
>     --<<--
> 
>     Then, I change file "drivers/char/agp/intel-agp.c" as this:
>     -->>--
>     --diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
>     index 9cf6e9b..e681f75 100644
>     --- a/drivers/char/agp/intel-agp.c
>     +++ b/drivers/char/agp/intel-agp.c
>     @@ -528,7 +528,8 @@ static void intel_i830_init_gtt_entries(void)
>                      * stolen, ignore it in stolen gtt entries counting.  However,
>                      * 4KB of the stolen memory doesn't get mapped to the GTT.
>                      */
>     -               size = 4;
>     +               /* size = 4; */
>     +               size = 516;
>             } else {
>                     /* On previous hardware, the GTT size was just what was
>                      * required to map the aperture.
>     --<<--
> 
>     And Xorg can start now.
> (1) Is it correct ?
>     Because older kernel use size as "512 + 4" at here, but now use "size = 4".
> (2) How to deal with it if the patch is not right ?
> (3) How to get more specification about gm4500 ?

