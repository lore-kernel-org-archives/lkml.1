Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYIOM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYIOM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYIOM5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 08:57:07 -0400
Received: from pih-relay04.plus.net ([212.159.14.17]:55166 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYIOM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 08:57:06 -0400
X-Greylist: delayed 2204 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 08:57:06 EDT
Message-ID: <48CE52EC.9060505@yahoo.com>
Date: Mon, 15 Sep 2008 13:19:56 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <48CE217A.1080409@tuffmail.co.uk>
In-Reply-To: <48CE217A.1080409@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 6cf9085fe8957900c6af018ee3d4893e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Firstly, I understand these kill-switches are supposed to be persistent
> over reboots.  You should check that the SD card stays disabled when you
> reboot.

The settings are persistent (so changing a camera value that is 0 to 1 
will show the camera as being enabled if you go to the BIOS). However 
the SD card will be present at reboot.

> Next, these settings are also exposed in the BIOS configuration screen,
> right?  If it's the same as my 701 then the BIOS will have a separate
> option for disabling the cardreader.  So you could see if the platform
> driver "camera" switch is simply disabling and enabling the two switches
> together.

The option for disabling the cardreader is indeed separate from the one 
to disable the camera. There is, however a switch for disabling USB in 
the BIOS too...

> Or if there's only a BIOS option for the camera, and not the SD card,
> then you should test whether it disables the SD card.

OK there are separate switches in the BIOS for disabling (among other 
things) the Camera, CardReader, and USB Ports.

Doing echo 0 > camera when camera is already 0 does nothing. The value 
in cardr remains 1.
Doing echo 0 > camera when camera is 1 seemingly results in the SD card 
disappearing too (ehci_hcd 0000:00:1d.7: HC died; cleaning up). cardr 
value remains 1. The CardReader and USB Ports options will be in the 
enabled state when looking in the BIOS after rebooting. The Camera 
option will be in the disabled state in the BIOS.
Doing echo 1 > camera after the SD card  has disappeared (but before 
rebooting) in the above step will result in the SD card seemingly coming 
back at a different address and the kernel reporting 'irq 23: nobody 
cared (try booting with the "irqpoll" option)' and a usb_hcd_irq backtrace.
Doing echo 0 > cardr when cardr is 1 results in the SD card disappearing 
and an ext3 error being printed on the console. The CardReader option 
will be in the disabled state in the BIOS after rebooting.
Doing echo 0 > camera after the SD card  has disappeared (but before 
rebooting) in the above step will result in 'ehci_hcd 0000:00:1d.7: HC 
died; cleaning up' being printed.

-- 
Sitsofe | http://sucs.org/~sits/
