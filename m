Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZCIP6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZCIP6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCIP6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:58:36 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:42601 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZCIP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:58:35 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Linux* Processor Microcode Data File
Date: Mon, 09 Mar 2009 11:58:22 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.0; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, tigran@aivazian.fsnet.co.uk
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
 <20090309081109.376f7a7e@infradead.org>
 <20090309153449.GB24213@silver.sucs.org>
In-reply-to: <20090309153449.GB24213@silver.sucs.org>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903091158.22918.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Sitsofe Wheeler wrote:
>On Mon, Mar 09, 2009 at 08:11:09AM -0700, Arjan van de Ven wrote:
>> On Mon, 9 Mar 2009 14:16:55 +0000
>>
>> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> > The kernel doesn't load microcode automatically
>>
>> it does if you have the right format; the kernel uses
>> request_firmware() for this.
>> The microcode on the intel website is not ready for this yet, but we're
>> working hard to have future drops to be in the new format.
>
>Wow so I was redundant AND wrong in the same email!
>
>What motivated the switch to the generic request_firmware interface? Is
>it just less messy/faster than previous methods?
>
>Additionally while I remember, is it worth updating the microcode on all
>machines? At present I have an EeePC 900 and it's unclear if it would
>benefit from a microcode update (but there's a definite cost to running
>the current initscript at boot).

Slight hijack of thread here, but...

I'll have to admit it was with some trepidation that I might brick my 
processor, which is a quad core AMD 9550, stepping 03 running at 2.2 ghz, but 
the directions didn't note until the end, that it would take a 2.6.29 series 
kernel to do it and I was running 2.6.28.7.  But when I got to the 
modprobe -r microcode, modprobe microcode part, there was no feedback from 
either command.  So did I, or did I not do this as I was and am running 
2.6.28.7?  The following was reported in my log:

Mar  9 07:22:04 coyote kernel: [65725.810333] microcode: collect_cpu_info_amd : patch_id=0x1000065                                       
Mar  9 07:22:04 coyote kernel: [65725.810338] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Mar  9 07:22:04 coyote kernel: [65725.847258] microcode: size 1936, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.847265] microcode: CPU0 patch does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022)
Mar  9 07:22:04 coyote kernel: [65725.847269] microcode: size 968, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.847278] microcode: CPU0 updated from revision 0x1000065 to 0x1000083
Mar  9 07:22:04 coyote kernel: [65725.847312] microcode: collect_cpu_info_amd : patch_id=0x1000065
Mar  9 07:22:04 coyote kernel: [65725.847317] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Mar  9 07:22:04 coyote kernel: [65725.851377] microcode: size 1936, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.851390] microcode: CPU1 patch does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022)
Mar  9 07:22:04 coyote kernel: [65725.851393] microcode: size 968, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.851403] microcode: CPU1 updated from revision 0x1000065 to 0x1000083
Mar  9 07:22:04 coyote kernel: [65725.851421] microcode: collect_cpu_info_amd : patch_id=0x1000065
Mar  9 07:22:04 coyote kernel: [65725.851426] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Mar  9 07:22:04 coyote kernel: [65725.855323] microcode: size 1936, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.855330] microcode: CPU2 patch does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022)
Mar  9 07:22:04 coyote kernel: [65725.855333] microcode: size 968, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.855344] microcode: CPU2 updated from revision 0x1000065 to 0x1000083
Mar  9 07:22:04 coyote kernel: [65725.855361] microcode: collect_cpu_info_amd : patch_id=0x1000065
Mar  9 07:22:04 coyote kernel: [65725.855365] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
Mar  9 07:22:04 coyote kernel: [65725.863101] microcode: size 1936, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.863107] microcode: CPU3 patch does not match (processor_rev_id: 1020, eqiv_cpu_id: 1022)
Mar  9 07:22:04 coyote kernel: [65725.863110] microcode: size 968, total_size 960
Mar  9 07:22:04 coyote kernel: [65725.863120] microcode: CPU3 updated from revision 0x1000065 to 0x1000083
Mar  9 07:22:04 coyote kernel: [65725.863122] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

Inquiring minds and all that.  Comments please?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"I have five dollars for each of you."
-- Bernhard Goetz

