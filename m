Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbXELSfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbXELSfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXELSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:34:56 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:19949 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbXELSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:34:55 -0400
Date: Sat, 12 May 2007 12:34:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [2.6.21.1] SATA freeze
In-reply-to: <fa.9rF0YSLySQV/+6iXNTOmlASflXA@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Gerhard Mack <gmack@innerfire.net>
Message-id: <464608C8.4050507@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nl0Mcy44vzL27dQ8CsLG/+SfNO0@ifi.uio.no>
 <fa.Odn/BmbDLGQp4kzhwqs6TScgkdE@ifi.uio.no>
 <fa.QtdEc9oISM5NdAmikW4kWhdGDeM@ifi.uio.no>
 <fa.YyeTl86xaR6Y3MLVL7vUm5SgUzc@ifi.uio.no>
 <fa.9rF0YSLySQV/+6iXNTOmlASflXA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> On Wed, 9 May 2007, Robert Hancock wrote:
>> Gerhard Mack wrote:
>>> On Wed, 9 May 2007, Jeff Garzik wrote:
>>>> Gerhard Mack wrote:
>>>>> May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0
>>>>> SErr
>>>>> 0x1800000 action 0x2 frozen
>>>>> May  9 14:51:35 mgerhard kernel: ata1.00: cmd
>>>>> 35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
>>>>> May  9 14:51:35 mgerhard kernel:          res
>>>>> 40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
>>>>> May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, please
>>>>> be
>>>>> patient (Status 0xd0)
>>>>>
>>>>> Anything I can do to figgure out what's causing this?
>> You're showing various flags set in the SError register, which suggests you're
>> having SATA communication problems with the drive. A bad SATA cable or power
>> problems would be a strong possibility.
>>
>> It really would be nice if we decoded these things more usefully for the user
>> (same with the regular ATA errors, like drivers/ide does), but in general
>> SError showing up as non-zero is a bad thing:
>>
>> 0x400000 = "Handshake error: When set to one, this bit indicates that one or
>> more R_ERR handshake response was received in response to frame transmission.
>> Such errors may be the result of a CRC error detected by the recipient, a
>> disparity or 10b/8b decoding error, or other error condition leading to a
>> negative handshake on a transmitted frame."
>>
>> 0x1800000 = "Link Sequence Error: When set to one, this bit indicates that one
>> or more Link state machine error conditions was encountered since the last
>> time this bit was cleared. The Link Layer state machine defines the conditions
>> under which the link layer detects an erroneous transition."
>>
>> and
>>
>> "Transport state transition error: When set to one, this bit indicates that an
>> error has occurred in the transition from one state to another within the
>> Transport layer since the last time this bit was cleared."
> 
> 
> Just out of curiosity how often is that bit cleared?

I believe that is cleared only on error handling or controller reset, so 
   it just means that it happened sometime since boot or the last libata 
error recovery.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

