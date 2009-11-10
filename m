Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZKJLGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZKJLGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZKJLGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:06:05 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59639 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZKJLGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gM5PvlNI/L0nmuaPJ7I5TLdJRqFrCxhwLQrw3F9IGyIjYCAkz743kwwhB1b4q2J4R1
         /Jy/kW+M6g5ZB93WxLKojDp0yGvogr8NL+H0glwEySrnbJ5iBVXnGbmR8XZy6JwUWoLk
         Y2gHtCZKuup24INQ8fvN3pZVQsvjwFEAYBT8k=
Date: Tue, 10 Nov 2009 12:06:01 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, dimm <dmitry.adamushko@gmail.com>
Subject: [PATCH 0/3] x86, ucode-amd: trim verbosity
Message-ID: <20091110110601.GG30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches make log messages of microcode_amd more terse.

Especially in conjunction with Dmitry's planned changes to summarize
patch level information this will help to trim messages to the
necessary minimum on systems with many CPUs.

Example (without patch 1 and 2) of a 48 CPU system:

  microcode: CPU0: patch_level=0x10000b5
  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  microcode: CPU0: cpu revision not listed in equivalent cpu table
  microcode: CPU0: cpu revision not listed in equivalent cpu table
  microcode: CPU1: patch_level=0x10000b5
  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  microcode: CPU1: cpu revision not listed in equivalent cpu table
  microcode: CPU1: cpu revision not listed in equivalent cpu table

  ...

  microcode: CPU46: patch_level=0x10000b5
  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  microcode: CPU46: cpu revision not listed in equivalent cpu table
  microcode: CPU46: cpu revision not listed in equivalent cpu table
  microcode: CPU47: patch_level=0x10000b5
  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  microcode: CPU47: cpu revision not listed in equivalent cpu table
  microcode: CPU47: cpu revision not listed in equivalent cpu table
  Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

This is a lot of unnecessary noise. With patches 1 and 2 applied this
is shortened to:

  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  microcode: CPU0: patch_level=0x10000b5
  microcode: CPU1: patch_level=0x10000b5

  ...

  microcode: CPU46: patch_level=0x10000b5
  microcode: CPU47: patch_level=0x10000b5
  Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

And with Dmitry's patches this will be trimmed down even further.
Note: Patch 3 is just a conversion from printk to pr_ macros.

Patches are against tip/master.
Please apply.


Thanks,

Andreas
