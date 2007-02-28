Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbXB1XXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbXB1XXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXB1XXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:23:48 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:17451 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXB1XXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:23:47 -0500
Date: Wed, 28 Feb 2007 17:22:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20 SATA error
In-reply-to: <fa.OO5sHloeJxxBmHwyt7Swo5eydUY@ifi.uio.no>
To: Charles Shannon Hendrix <shannon@widomaker.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Gerhard Mack <gmack@innerfire.net>
Message-id: <45E60EBB.7030805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
 <fa.OO5sHloeJxxBmHwyt7Swo5eydUY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> On Wed, 28 Feb 2007 07:40:23 -0500 (EST)
> Gerhard Mack <gmack@innerfire.net> wrote:
> 
>> hello, 
>>
>> Can someone tell me what this means?
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
>> ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 
>> out
>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata1: port is slow to respond, please be patient (Status 0xd0)
>> ata1: port failed to respond (30 secs, Status 0xd0)
>> ata1: soft resetting port
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata1.00: configured for UDMA/100
> 
> I am fairly certain this is a bug in the 2.6.20 kernel.
> 
> I never see it in 2.6.19*, just 2.6.20.
> 
> It is some kind of but in the SATA code paths, or at least that's all it
> appears to affect on my system.
> 
> What chipset do you have?
> 
> I have an nforce4 chipset.
> 
> In another thread, I think they were saying it was either a SATA chipset
> driver bug, or a problem in libata core.

There's a known issue with sata_nv on nForce4 controllers running in 
ADMA mode in 2.6.20 (the first released kernel with ADMA support) where 
commands can time out when switching between NCQ commands and non-NCQ 
commands. Hopefully this is fixed in 2.6.21-rc. This doesn't seem to be 
the issue here, since his system isn't using ADMA mode, for reasons 
unclear to me..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

