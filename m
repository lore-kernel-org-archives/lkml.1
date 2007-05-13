Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbXEMBCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbXEMBCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 21:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbXEMBCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 21:02:42 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38859 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbXEMBCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 21:02:41 -0400
Date: Sat, 12 May 2007 19:02:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [2.6.21.1] SATA freeze
In-reply-to: <464610F7.6030202@redhotpenguin.com>
To: Fred Moyer <fred@redhotpenguin.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Message-id: <464663AE.6040409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no>
 <46460C1B.6000609@shaw.ca> <464610F7.6030202@redhotpenguin.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fred Moyer wrote:
>> This appears to be a different problem. Something is issuing 
>> SMART-related commands (smartd or smartctl perhaps) which the drive 
>> seems to be reacting strangely to. It apparently completed the command 
>> but never raised DRQ to request any data being transferred even though 
>> we expected it to. Maybe SMART is disabled on the drive and that's 
>> causing it to just toss these commands? CCing linux-ide in case anyone 
>> knows what would cause this.
> 
> Here's smartctl -a for this drive - same output for both sda and sdb. 
> Smartd is currently running.  Any advice appreciated.
> 
> Previously on 2.6.15 I was seeing sdb remount as readonly under heavy 
> i/o.  I have not seen that issue yet with 2.6.21 (with Robert's patch 
> from May 5th for sata_nv), but that occurrence of remounts read-only was 
> infrequently, so that issue may be solved.
> 
> app2 ~ # smartctl -a /dev/sda
> smartctl version 5.36 [x86_64-pc-linux-gnu] Copyright (C) 2002-6 Bruce 
> Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Device: ATA      ST3808110AS      Version: n/a
> Serial number:             5LR8895K
> Device type: disk
> Local Time is: Sat May 12 12:05:58 2007 PDT
> Device does not support SMART
> 
> Error Counter logging not supported
> 
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
> Device does not support Self Test logging
> 

Sounds like SMART is likely disabled on that drive. You can try doing 
"smartctl -s on /dev/sda" and see if that will turn it on.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

