Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYKJP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYKJP0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYKJP0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:26:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:22580 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYKJP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:26:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sUxlMpODB9r0v+HpfzkY4dhlMOuz7nyT7owvBxocbj6aaHumN7xWVRGYzXO0DNwEZO
         e2hZp5pa0BX0VmnCYCPjvJ0ikzvJdofgNBYKkd+tbPWyVHi12mlwgn4aC/I5YPJpmKyA
         572QtJDMx4uT2gJU7HN2+E/mz/3WZRSTJsaEE=
Date: Mon, 10 Nov 2008 23:25:18 +0800
From: arrow.ebd@gmail.com
To: linux_kernel <linux-kernel@vger.kernel.org>
Subject: thinkpad x200 X.server not work with gm4500 graphics
Message-ID: <20081110152518.GA3545@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

deal,

    My thinkpad x200's X.server can not startup on the kernel 2.6.28,
and dmesg will show as below:
    -->>--
    [drm] Initialized drm 1.1.0 20060810
    pci 0000:00:02.0: power state changed by ACPI to D0
    pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
    pci 0000:00:02.0: setting latency timer to 64
    [drm] Initialized i915 1.6.0 20060119 on minor 0
    pci 0000:00:02.0: pg_start == 0x00001f7f, intel_private.gtt_entries == 0x00001fff
    pci 0000:00:02.0: trying to insert into local/stolen memory
    --<<--

    Then, I change file "drivers/char/agp/intel-agp.c" as this:
    -->>--
    --diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
    index 9cf6e9b..e681f75 100644
    --- a/drivers/char/agp/intel-agp.c
    +++ b/drivers/char/agp/intel-agp.c
    @@ -528,7 +528,8 @@ static void intel_i830_init_gtt_entries(void)
                     * stolen, ignore it in stolen gtt entries counting.  However,
                     * 4KB of the stolen memory doesn't get mapped to the GTT.
                     */
    -               size = 4;
    +               /* size = 4; */
    +               size = 516;
            } else {
                    /* On previous hardware, the GTT size was just what was
                     * required to map the aperture.
    --<<--

    And Xorg can start now.
(1) Is it correct ?
    Because older kernel use size as "512 + 4" at here, but now use "size = 4".
(2) How to deal with it if the patch is not right ?
(3) How to get more specification about gm4500 ?
