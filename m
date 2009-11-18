Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZKRA2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZKRA2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZKRA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:28:14 -0500
Received: from smtp12.ono.com ([62.42.230.20]:35459 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752910AbZKRA2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:28:14 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 19:28:14 EST
Date: Wed, 18 Nov 2009 01:22:58 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Wrong path for ucode in udev
Message-ID: <20091118012258.765b7b74@werewolf.home>
X-Mailer: Claws Mail 3.7.3cvs12 (GTK+ 2.18.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I'm trying to see if my CPU needs an ucode update or not.
I want to see if I get positive feedback from the kernel, but I see a couple
problems:

- I hacked the firmware.sh script with a couple debug lines:

logger "$DIR/$FIRMWARE"
logger /sys$DEVPATH

And i get this:

Nov 17 17:01:53 bran logger: /lib/firmware/intel-ucode/0f-02-09
Nov 17 17:01:53 bran logger: /sys/devices/platform/microcode/firmware/microcode

In that second path, firmware.sh looks for /data, /loading, etc.
The problem is that path _doesn't exist_.
Is firmware.sh out of date ? Or the kernel is missing something ?

- The kernel does not give any info about successful load, even when microcode_ctl
  writes to /dev/cpu/microcode (as the split files still do not exist...)

Any ideas ?

kernel is 2.6.31.6, udev is 147.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
