Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYG3RtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYG3RtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYG3Rs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:48:57 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:59629 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYG3Rs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:48:57 -0400
Message-ID: <4890A563.70609@dolphinics.no>
Date: Wed, 30 Jul 2008 19:31:15 +0200
From: Simen Timian Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with
 libata
References: <48838593.8020007@dolphinics.no> <200807202103.51889.alistair@devzero.co.uk> <488CCD81.7010002@dolphinics.no> <200807272147.42264.alistair@devzero.co.uk>
In-Reply-To: <200807272147.42264.alistair@devzero.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 27 July 2008 20:33:21 Simen Timian Thoresen wrote:
> [snip]
>> I've spent a few hours more looking into this, and I'm not really
>> getting much clearer;
>>
>> I've run either and both of the two DVDroms on an external power-supply
>> (drive-power from a jumped, believed good ATX-PSU), and the the symptoms
>> remain; inconsistent capabilities reported at boot, and when I start
>> ripping CDs, one of them will fail as above.
>>
>> As I still have the impression that this started when I switched distros
>> (ie went from CentOS4 2.6.9 pre-libata-kernel to the current Ubuntu 8.04
>> 2.6.24-kernel), I've now started playing around with the libata module
>> parameters.

Hi Alistair,

I'm sorry I have not yet come back on this. I /think/ I've had success 
disabling DMA for atapi-devices (adding "options libata dma=5" to my 
modprobe.conf file). I've been able to rip a number of cds without any 
issues with this (except a reduced speed, I believe). I do get some 
noise in dmesg;

[ 9686.570804] end_request: I/O error, dev sr1, sector 0
[ 9686.570814] Buffer I/O error on device sr1, logical block 0
[ 9686.570819] Buffer I/O error on device sr1, logical block 1
[ 9686.572134] end_request: I/O error, dev sr1, sector 1024
[ 9686.573105] end_request: I/O error, dev sr1, sector 1024
[ 9686.574101] end_request: I/O error, dev sr1, sector 1024


...but cdparianoia (ripper application) never complains and I've not 
been able to notice any defects in the extracted audio.

As this was disabling DMA, and I've seen that frequency adjustments on 
the CPU can cause DMA issues (at the time, with the ivtv-driver) on this 
motherboard, I thought that I'd try disabling Cool'n'Quiet and thereby 
lock the CPU to full speed, while reenabling DMA, but that did not help. 
Ripping the first CDs, one of the drives failed again.

> If it's not power then I'm still with Alan re the cables. Maybe you have very 
> long cables?

Nope, normal 40cm'is 80-pin IDE cables. While one could be bad, I 
wouldn't expect both to be (etc).

> I used Alan's nForce4 pata driver for a year or so and didn't have any 
> problems. OTOH maybe at this stage it's worth checking whether amd74xx (old 
> IDE) breaks in similar ways?

from dmesg, I have this;

[   17.647757] pata_amd 0000:00:06.0: version 0.3.10
[   17.650097] scsi0 : pata_amd
[   17.650229] scsi1 : pata_amd
(that's the one, right?)

...so the driver exists in the running kernel. Would I have to build my 
own kernel, or is there some way to have this driver take hold instead 
of libata? ...or can I do something in modprobe.conf to use the other 
driver?

> Also, I assume you've memtest86'ed the machine?

Not strictly recently. I'll leave it doing so this evening, as I'll want 
to reboot it to reactivate Cool'n'quiet.

Again, thank you for helping me look into this. For now it /looks/ like 
I could be happy doing PIO, but I'd prefer to have this solved properly 
if possible.

-S

-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support
