Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbZJFMeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbZJFMeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbZJFMeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:34:13 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48579 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbZJFMeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:34:12 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 08:34:12 EDT
Message-ID: <4ACB3741.2030101@gmail.com>
Date: Tue, 06 Oct 2009 15:25:37 +0300
From: Harri Olin <harri.olin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Bernie Innocenti <bernie@codewiz.org>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
In-Reply-To: <4ACA6904.1060509@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2009 12:25:41.0310 (UTC) FILETIME=[1E63DDE0:01CA4680]
X-CT-RefID: str=0001.0A0B0205.4ACB3745.02D8,ss=1,fgs=0
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Bernie Innocenti wrote:
>> The error in the subject appears in the console immediately followed bv
>> a hard freeze of the machine.  The error occurs reproducibly on two
>> identical Opteron servers, each one equipped with two identical
>> controller cards:
>>
>> 03:04.0 SCSI storage controller: Marvell Technology Group Ltd. 
>> MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
>> 03:06.0 SCSI storage controller: Marvell Technology Group Ltd. 
>> MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
>>
>> We can trigger the problem within a few seconds by starting a
>> reconstruction on a drive hooked to port 4 (counting from 0) of the
>> second controller.  Oddly, every other drive works reliably and the
>> faulty drive works if we connect it to, for example, port 4 of the first
>> controller.
>>
>> Tested with Debian kernels 2.6.26-19 and 2.6.30-8.  Let me know if
>> further details are needed.
> ..
>> 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040..
> ..
>
>  0x30000040 here means "MRdPerr":
>    "bad data parity detected during PCI master read".
>
> Which means there that a data parity error happened
> during outgoing data transfer on the PCI-X bus.
> This could happen due to noise on the bus,
> dying capacitors, or (?) bad RAM (not sure about the last one).
>
I have heard same thing happened with same kind of configuration, using 
Supermicro H8DME-2 motherboard, Opteron 2378 CPU.

Even the controllers were on same slots.

My initial suspicion was that the motherboard does not drop the PCI-X 
bus frequency to 100MHz and drives the bus at 133MHz even though there 
are 2 controllers connected. Proposed fix was to move the other 
controller to other bus, as the H8DME-2 has four PCI-X slots, 2x100MHz 
and 2x133MHz, but I haven't yet heard back if it helped.

Even the kernel was same - latest Debian distribution kernel. Might be 
worthwile to try using vanilla kernel.org kernel if possible.

I have at home two 6081 controllers at same bus but at 100MHz and no 
problems yet.

-- 
Harri.



