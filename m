Return-Path: <linux-kernel-owner+w=401wt.eu-S937546AbYD1Up4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937546AbYD1Up4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbYD1Upr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:45:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:61260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbYD1Upq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LdRc4GWmjQ+68nLIJVcjekw/LbvxPyaNcf/4T2wqNFa1vxGHt44CHhFjsjS72UCAiH+XTuu5oIBmcaZpeVkdtEIkuA7pV/sw/axIl1F2W1/xGbknsPXGzuz9K3tOYPiGSrNQPocx76Ac1UjigCn4ok/PmDwKAHh5osdSsmLs+cM=
Message-ID: <4816376B.8060907@googlemail.com>
Date: Mon, 28 Apr 2008 22:45:31 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Mika Fischer <mika.fischer@zoopnet.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org>	 <48132665.8050202@googlemail.com>	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>	 <48159668.5010808@googlemail.com>	 <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>	 <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>	 <4815DB15.4070908@zoopnet.de> <4815DE0C.6000802@googlemail.com> <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com> <481627B7.9060406@googlemail.com>
In-Reply-To: <481627B7.9060406@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Yinghai Lu wrote:
>> On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>> Mika Fischer wrote:
>>>  > Hi Ingo,
>>>  >
>>>  > I'm having the same problem.
>>>  >
>>>  > Ingo Molnar schrieb:
>>>  >> excellent. So just to make sure: this box never had proper graphics
>>>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>>>  >> up the MTRR's, right?
>>>  >
>>>  > Well, not quite. X still works fine, but since the video memory is
>>>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>>>  > range for the video memory. That makes X rather slow especially if you
>>>  > use DRI for Compiz etc.
>>>
>>>  Well you are lucky then :)
>>>
>>>  Yeah X 'worked' but it worked as slow as with vesa video driver here.
>> [    0.000000] rangeX: 0000000000000000 - 00000000d0000000
>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>> [    0.000000] range0: 00000000cf800000 - 00000000cf800000
>> [    0.000000] range: 00000000cf800000 - 00000000d0000000
>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>> [    0.000000] range0: 0000000100000000 - 0000000120000000
>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>> [    0.000000] range: 0000000120000000 - 0000000130000000
>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>> [    0.000000] hole: 000000012c000000 - 0000000130000000
>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>>
>> so your X server need two entries for WB?
>>
>> can you send out /proc/mtrr with booting with disable_mtrr_cleanup?
> 
> I can just not right now , cannot reboot the box yet. In about 1h or so , maybe less.

Here the output with v3 which is disabled by default:

--($:~)-- cat /proc/mtrr
reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1

dmesg is saying now :

[   22.764595] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining


My card settings in BIOS ( that was default ) are the following :

DVMT Mode -> DVMT Mode ( possible setting DVMT Mode or Fixed Mode )
DVMT / Memory -> 256MB ( possible settings 128/256 MB or Maximum DVMT )

Initiate Graphics Adapter -> PEG/PCI ( possible settings IGD , PCI/IGD , PCI/PEG , PEG/IGD )
Internal Graphics Mode Select -> Enabled,8MB ( possible settings Enabled,8MB , Enabled,1MB maybe Disabled I forgot to look)
PEG Port -> Auto ( possible settings Auto , Disabled )
PEG Port Force x1 -> Disabled ( possible settings Enabled , Disabled )

Of course these settings are only possible when the card is not disabled :)

I'm gonna try v4 now and enable it. Please let me know if you need more infos.

Gabriel
