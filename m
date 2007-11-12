Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbXKLD5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbXKLD5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 22:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXKLD5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 22:57:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:5554 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXKLD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 22:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MiB11zBho7rl0xO/bjWsATF9fciCKEPGW53vf7qk0pOm8P070INKYQp6NFX6aPdwZ+Xlw4vWukyKjGt3dg6zbRT/Fb4acPL2mFnGpi3C+ZtM0XNed9TcZM8J018KyaEFnYBx6QegrKIfXq2t42c0N7A8S0r4iPuQBKIcDMk0e+k=
Message-ID: <4737CF25.6070100@gmail.com>
Date: Mon, 12 Nov 2007 12:57:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: SATA eating my disk, port reset, destroying unrelated data
References: <fa.49dhbrKdHhj8Seg3o+OTGRYqytk@ifi.uio.no> <473256BD.1080205@shaw.ca>
In-Reply-To: <473256BD.1080205@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Norbert Preining wrote:
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2
> 
> Serror 0x400000 means a handshake error. Usually Serror indications are
> due to a hardware problem (bad SATA cable, power or drive problem).
> 
>> ata1.00: (BMDMA stat 0x25)
>> ata1.00: cmd 35/00:00:2a:6f:c0/00:04:0c:00:00/e0 tag 0 cdb 0x0 data
>> 524288 out
>>          res 51/84:10:1a:72:c0/84:01:0c:00:00/e0 Emask 0x10 (ATA bus
>> error)

And error register value 0x84 - ICRC (CRC error on ATA bus) and ABRT
(command abort) - agrees with what SError indicates.  You're
experiencing transmission errors.

>> ata1: soft resetting port
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata1.00: configured for UDMA/133
>> ata1: EH complete
>>
>> Even worse, sometimes the reset does not work ...
>>
>> ata1: device not ready (errno=-16), forcing hardreset
>> ata1: hard resetting port
>> ata1 SRST failed (errno=-19)
>> ata1: reset failed (errno=-19), retrying in 10 secs
>> ..
>>
>> (typed from a digital photo, nothing remains in the logs)
>>
>> After this I need to do a cold boot otherwise the drive is really in a
>> bad state and not even the bios gets it right.
> 
> If even the BIOS cannot reset properly then that also really points to a
> hardware problem..

Also, firmware on some harddrives die solidly when transmission errors
occur.  Maybe yours is one.  There's nothing much the driver can do
about both the transmission error and the drive locking up afterward.
If the transmission errors occur frequently, the chance is that either
your drive or power supply is dying.  As for the drive lock up, maybe
firmware update will help.

* "smartctl -a /dev/sda" might report something interesting.

* Connect the drive to different SATA and power connector and see if the
problem persists.

* Connect the drive to a separate power supply and see if the problem
persists.

-- 
tejun
