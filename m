Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXCLCIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXCLCIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 22:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXCLCIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 22:08:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40948 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbXCLCIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 22:08:39 -0400
Message-ID: <45F4B624.7010901@vandrovec.name>
Date: Sun, 11 Mar 2007 19:08:36 -0700
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070217 Iceape/1.0.8 (Debian-1.0.8-3)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, Hans-Frieder Vogt <hfvogt@gmx.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nForce MCP61 support to i2c-nforce2
References: <20070310080003.GA24177@vana.vc.cvut.cz> <20070310202941.165b28a0.khali@linux-fr.org>
In-Reply-To: <20070310202941.165b28a0.khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2007 02:08:36.0074 (UTC) FILETIME=[57BDF4A0:01C7644B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Petr,
> 
> On Sat, 10 Mar 2007 09:00:03 +0100, Petr Vandrovec wrote:
>> Hello,
>>   patch below adds support for nVidia's SMBus adapter present on Gateway's GT5414E 
>> motherboard (ECS's MCP61 PM-AM).  Patch is for current Linus's git tree.
> 
> We already have a patch doing exactly this in -mm:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/broken-out/jdelvare-i2c-i2c-nforce2-add-mcp61-mcp65-support.patch

Thanks.

>> 00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
>>         Subsystem: Elitegroup Computer Systems Unknown device 2601
>>         Flags: 66MHz, fast devsel, IRQ 10
>>         I/O ports at fc00 [size=64]
>>         I/O ports at 1c00 [size=64]
>>         I/O ports at f400 [size=64]
>>         Capabilities: [44] Power Management version 2
> 
> BTW, note how the MCP61 has not 2 but 3 64-byte I/O areas declared. The
> previous chips used BAR 4 and 5, this new one additionally uses BAR 0.
> Without documentation it's hard to be sure this is a 3rd SMBus channel,
> but it sure looks so. Maybe you'll want to hack the i2c-nforce2 driver
> a bit to confirm or infirm this theory.

I had same idea as you have, so I tried to modify driver to use BAR0 as 
well, and (1) i2cdump then said that nobody is there and (2) dump of 
range fc00 was quite different from range 1c00 and f400.

So for my hardware I'm sure that BAR0 is of no use for me - if it is 3rd 
channel then either it uses different interface from nforce2, or nothing 
is connected to it.
								Petr
