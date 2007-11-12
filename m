Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXKLRAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXKLRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXKLQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:59:55 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:58338 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXKLQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:59:54 -0500
X-IronPort-AV: E=Sophos;i="4.21,406,1188802800"; 
   d="scan'208";a="415183955"
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
X-Message-Flag: Warning: May contain useful information
References: <ada1wb05p6n.fsf@cisco.com> <s5hbq9zyktm.wl%tiwai@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 12 Nov 2007 08:59:49 -0800
In-Reply-To: <s5hbq9zyktm.wl%tiwai@suse.de> (Takashi Iwai's message of "Mon, 12 Nov 2007 08:39:01 +0100")
Message-ID: <adak5on2yd6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Nov 2007 16:59:49.0479 (UTC) FILETIME=[6F94C770:01C8254D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > You seem to pass unneeded module options to snd-hda-intel driver like
 > MSI enablement.  First, try to remove all these options.

Yes, it's trivial to reproduce without any options:

    [ 2311.759856] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
    [ 2311.759866] hda_intel: probe_mask set to 0x1 for device 17aa:2010
    [ 2311.759886] PCI: Setting latency timer of device 0000:00:1b.0 to 64
    [ 2312.911309] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x003f000c

(By the way, what's wrong with using the enable_msi option?  MSI seems
very solid on Intel platforms, and I prefer avoiding shared interrupts)

 - R.
