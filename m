Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZLCEfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZLCEfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZLCEe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:34:59 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:54476 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbZLCEe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:34:58 -0500
Date: Wed, 02 Dec 2009 23:34:40 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Bug (minor): microcode_intel.c applies updates to hyperthreaded
 cores
In-reply-to: <20091202202012.0c7b6768@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B173FE0.7030302@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B17393B.7000304@majjas.com>
 <20091202202012.0c7b6768@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre)
 Gecko/20091109 Fedora/3.0-3.10.b4.fc12 Thunderbird/3.0b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fair point - guess it's a different bug. Looks like the mechanism sets 
up the requests first for all cpus, then loads them. apply_microcode 
doesn't recheck.

CPU is a core i7 920; ht enabled. cpuinfo shows 4 cores; 8 cpus, as 
expected.




 From my log:
Dec  2 16:53:47 mail kernel: microcode: CPU0 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU1 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU2 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU3 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU4 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU5 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU6 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU7 sig=0x106a5, pf=0x2, 
revision=0xf
Dec  2 16:53:47 mail kernel: platform microcode: firmware: requesting 
intel-ucode/06-1a-05
Dec  2 16:53:47 mail kernel: microcode: CPU0 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU1 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU2 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU3 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU4 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU5 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU6 updated to revision 0x11, 
date = 2009-04-14
Dec  2 16:53:47 mail kernel: microcode: CPU7 updated to revision 0x11, 
date = 2009-04-14


On 12/02/2009 11:20 PM, Arjan van de Ven wrote:
> On Wed, 02 Dec 2009 23:06:19 -0500
> Michael Breuer<mbreuer@majjas.com>  wrote:
>
>    
>> According to spec, microcode should only be applied to actual cores.
>> As things are currently structured, looks like the fix would be in
>> microcode_core.c. I don't think changing the loop to look for cores
>> vs. cpu's would affect anything adversely, but honestly am not
>> familiar enough with this code or other cpu types to be sure.
>>
>>      
> isn't this
>
> for each (logical) cpu
>     check microcode version of the cpu
>     if too old, apply microcode
>
> the 2nd pair of a hyperthreading pair will never see the 'too old' case
> happen...
>
>
>    

