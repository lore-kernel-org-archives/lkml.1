Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXCLPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXCLPZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXCLPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:25:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57153 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030371AbXCLPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:25:11 -0400
Date: Mon, 12 Mar 2007 16:25:13 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21rc3: usb 2-2: pl2303 converter now attached to ttyUSB44
Message-ID: <20070312152513.GO18731@stusta.de>
References: <200703071022.04409.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703071022.04409.arekm@maven.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 10:22:04AM +0100, Arkadiusz Miskiewicz wrote:
> 
> 2.6.21rc3 from today git, thinkpad z60m, pl2303 usb-rs232 adapter and:
> 
> [   84.087080] usb 2-2: new full speed USB device using uhci_hcd and address 3
> [   84.232615] usb 2-2: configuration #1 chosen from 1 choice
> [   84.235540] pl2303 2-2:1.0: pl2303 converter detected
> [   84.235732] usb 2-2: pl2303 converter now attached to ttyUSB44
> 
> With older kernels this was ttyUSB0, now it's ttyUSB44 huh, doesn't seem 
> correct, right?
> 
> [arekm@tarm ~]$ ls -l /dev/tts
> razem 0
> crw-rw---- 1 root ttyS   4, 64 2007-03-07 10:58 0
> crw-rw---- 1 root ttyS   4, 65 2007-03-07 10:58 1
> crw-rw---- 1 root ttyS   4, 66 2007-03-07 10:58 2
> crw-rw---- 1 root ttyS   4, 67 2007-03-07 10:58 3
> crw-rw---- 1 root ttyS 188, 44 2007-03-07 10:17 USB44
> 
> Of course it doesn't work. minicom says that there is no device there.
> 
> cat test also:
> cat: /dev/tts/USB44: No such device

Thanks for your report.

Can you confirm that it's the following issue, and therefore fixed for 
you in the latest -git?

Subject    : usb-serial broken
             (devices shows up as ttyUSB44 or ttyUSB140 instead of ttyUSB0)
Submitter  : Craig Schlenter <craig@codefountain.com>
Caused-By  : Oliver Neukum <oneukum@suse.de>
             commit 34ef50e5b1f96c2d8c0f3d28b7d407743806256c
Fixed-By   : Oliver Neukum <oneukum@suse.de>
Commit     : c744f99eb662b54488304b8b60e5f4323b7587bf
Status     : fixed in -rc3-git6

> Arkadiusz Miśkiewicz

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

