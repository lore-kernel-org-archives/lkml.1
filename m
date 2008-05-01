Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYEANpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYEANpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYEANpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:45:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYEANpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:45:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819C941.6030209@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 15:44:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: linux-kernel@vger.kernel.org, Kristian Hoegsberg <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-git16 -- BUG: unable to handle kernel NULL pointer dereference
 at 00000000 -- IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>	 <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de> <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com>
In-Reply-To: <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> Hi Stefan.  Thanks for your patch.  It worked great.

Good, thanks for reporting and testing.

> Now I see this in the logs:
> 
> ohci1394: fw-host0: SelfID received outside of bus reset sequence
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> Program usplash tried to access /dev/mem between 0->8000000.
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0f54000000173]
> ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00e018000027d06c]
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> IEEE 1394 device has ROM CRC error
> 
> Also, "cat /sys/bus/ieee1394/drivers/raw1394/device_ids" no longer
> causes an error.
> 
> Is it necessary for the code to spit out so many CRC errors for the
> OrangeMicro iBot?

I could look into keeping those messages down to only a single one per 
attempt to fetch the so-called configuration ROM of an added node.

> Also, are these errors indicating a significant
> problem with the iBot?

The config ROM is an area in the IEEE 1394 address space of a node which 
contains information about the device functions.  It consists of a 
header, a root directory, and subdirectories.  Each one of those has 
CRCs as one safeguard (among others) against integrity issues with the 
data read from the ROM.

A few devices, especially older ones, got the CRC algorithm wrong. Hence 
we don't reject those devices, we only warn about them as a starting 
point for further diagnosis in case that more than this goes wrong when 
using the device.

(The ROM CRC error warning has been added in 2.6.22.  Before Linux 
2.6.22, the ROM CRC errors were silently accepted.  The new alternative 
firewire drivers also do not warn about ROM CRC errors... yet...)
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
