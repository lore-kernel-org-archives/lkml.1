Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZACNQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZACNQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 08:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZACNP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 08:15:56 -0500
Received: from lucidpixels.com ([75.144.35.66]:56517 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZACNPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 08:15:55 -0500
Date: Sat, 3 Jan 2009 08:15:52 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mark Lord <liml@rtr.ca>
cc: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native  
 293046768
In-Reply-To: <495B9ED3.8050008@rtr.ca>
Message-ID: <alpine.DEB.1.10.0901030813410.31871@p34.internal.lan>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan> <495A5A9F.9020406@shaw.ca> <495B9ED3.8050008@rtr.ca>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Mark Lord wrote:

> Robert Hancock wrote:
>> Justin Piszcz wrote:
>>> On one system, two Raptor 150s:
>>> 
>>> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
> ..
>> Presumably somebody or something set up a host protected area on one drive 
>> and not the other.. I believe there are some utilities out there that can 
>> be used to disable the HPA and allow the full capacity to be used.
> ..
>
> "hdparm -N" can do this, temporarily or permanently.
> Get the latest version from Sourceforge, and see the manpage for details.
>
> -ml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Just incase someone Google's this later on, this is what it looks like,
for my case:

The /dev/sda (first disk) is the one with the problem.

root@Knoppix:~/hpa# hdparm -N /dev/sda

/dev/sda:
  max sectors   = 293044655/293046768, HPA is enabled
root@Knoppix:~/hpa# hdparm -N /dev/sdb

/dev/sdb:
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~/hpa# hdparm -N p293046768 /dev/sda

/dev/sda:
  setting max visible sectors to 293046768 (permanent)
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~/hpa#

root@Knoppix:~# hdparm -N /dev/sda

/dev/sda:
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~#

1. I backed up the volume of the RAID-1 array.
2. Failed out the disk with the problem.
3. Then ran the commands above.
4. Reboot back to the OS.
5. Re-add the disk back into the RAID-1.


Justin.

