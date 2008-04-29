Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYD2BGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYD2BGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYD2BGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:06:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:58835 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYD2BGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=n+RpHSep55iGJyiX4gr8inU87yZ5K4wvKwUDOSsdND/h/0U16I8uM+R8zCiIEt4fbWiKmUp4BkB6xlqJ3Gt4LnQyKUDoeHAHAIO/vJj2dOaKqCIO1JiJxbkFNAsRQycO1yPA5I0rk7VDayahJqY7FFwd6wqCPOQTNwCiC63+OKo=
Message-ID: <48167473.80207@googlemail.com>
Date: Tue, 29 Apr 2008 03:05:55 +0200
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
References: <200801192045.17291.yinghai.lu@sun.com>	 <20080428135351.GF3973@elte.hu> <4815DB15.4070908@zoopnet.de>	 <4815DE0C.6000802@googlemail.com>	 <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com>	 <481627B7.9060406@googlemail.com> <4816376B.8060907@googlemail.com>	 <48163F56.70704@googlemail.com>	 <86802c440804281503q1f9e6f8anb18cd514e89b76fe@mail.gmail.com>	 <4816562B.2070905@googlemail.com> <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com>
In-Reply-To: <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Apr 28, 2008 at 3:56 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Yinghai Lu wrote:
>>  > On Mon, Apr 28, 2008 at 2:19 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>  >> Gabriel C wrote:
>>  >>  > Gabriel C wrote:
>>  >>  >> Yinghai Lu wrote:
>>  >>  >>> On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>  >>  >>>> Mika Fischer wrote:
>>  >>  >>>>  > Hi Ingo,
>>  >>  >>>>  >
>>  >>  >>>>  > I'm having the same problem.
>>  >>  >>>>  >
>>  >>  >>>>  > Ingo Molnar schrieb:
>>  >>  >>>>  >> excellent. So just to make sure: this box never had proper graphics
>>  >>  >>>>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>>  >>  >>>>  >> up the MTRR's, right?
>>  >>  >>>>  >
>>  >>  >>>>  > Well, not quite. X still works fine, but since the video memory is
>>  >>  >>>>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>>  >>  >>>>  > range for the video memory. That makes X rather slow especially if you
>>  >>  >>>>  > use DRI for Compiz etc.
>>  >>  >>>>
>>  >>  >>>>  Well you are lucky then :)
>>  >>  >>>>
>>  >>  >>>>  Yeah X 'worked' but it worked as slow as with vesa video driver here.
>>  >>  >>> [    0.000000] rangeX: 0000000000000000 - 00000000d0000000
>>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>>  >>  >>> [    0.000000] range0: 00000000cf800000 - 00000000cf800000
>>  >>  >>> [    0.000000] range: 00000000cf800000 - 00000000d0000000
>>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>>  >>  >>> [    0.000000] range0: 0000000100000000 - 0000000120000000
>>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>>  >>  >>> [    0.000000] range: 0000000120000000 - 0000000130000000
>>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>>  >>  >>> [    0.000000] hole: 000000012c000000 - 0000000130000000
>>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>>  >>  >>>
>>  >>  >>> so your X server need two entries for WB?
>>  >>  >>>
>>  >>  >>> can you send out /proc/mtrr with booting with disable_mtrr_cleanup?
>>  >>  >> I can just not right now , cannot reboot the box yet. In about 1h or so , maybe less.
>>  >>  >
>>  >>  > Here the output with v3 which is disabled by default:
>>  >>  >
>>  >>  > --($:~)-- cat /proc/mtrr
>>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>>  >>  >
>>  >>  > dmesg is saying now :
>>  >>  >
>>  >>  > [   22.764595] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
>>  >>  >
>>  >>  >
>>  >>  > My card settings in BIOS ( that was default ) are the following :
>>  >>  >
>>  >>  > DVMT Mode -> DVMT Mode ( possible setting DVMT Mode or Fixed Mode )
>>  >>  > DVMT / Memory -> 256MB ( possible settings 128/256 MB or Maximum DVMT )
>>  >>  >
>>  >>  > Initiate Graphics Adapter -> PEG/PCI ( possible settings IGD , PCI/IGD , PCI/PEG , PEG/IGD )
>>  >>  > Internal Graphics Mode Select -> Enabled,8MB ( possible settings Enabled,8MB , Enabled,1MB maybe Disabled I forgot to look)
>>  >>  > PEG Port -> Auto ( possible settings Auto , Disabled )
>>  >>  > PEG Port Force x1 -> Disabled ( possible settings Enabled , Disabled )
>>  >>  >
>>  >>  > Of course these settings are only possible when the card is not disabled :)
>>  >>  >
>>  >>  > I'm gonna try v4 now and enable it. Please let me know if you need more infos.
>>  >>
>>  >>  Hmm v4 doesn't work anymore here ( I've tested with all possible settings in BIOS ).
>>  >>  It takes 6 minutes to boot to :
>>  >>
>>  >
>>  > so you card is using 256M and 8M? 0xd0000000-0xe0000000, where is
>>  > another 8M address.
>>
>>  Looks like this , yes. Is using the 256MB Memory and the 8MB for Graphics Mode Select.
>>
>>  I'm not really sure why the 8MB are needed , BIOS book doesn't tell me.
>>  I could try to disable and see what I get =)
>>
>>
>>
>>  >
>>  > mtrr by BIOS is very interesting:
>>  > before
>>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>>  >
>>  >
>>  > after 256M chunk size got
>>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>>  >
>>  > so the convering is right..., need to spare another entry for your card.
>>  >
>>  > or we can dumping the
>>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>>  > for extra entra...
>>  >
>>  > but the mtrr trimming code need to be updated instead of only using highest_pfn
>>  >
>>  > YH
>>  >
> 
> please try to test patch with mtrr_chunk_size= 2g; 1g, 512m, 128m. etc.
> only for test: i comment out the fill_var_state..

There are the dmesg's , down to 2m and without chunk_size :

http://frugalware.org/~crazy/mtrr/mtrr/

> 
> YH
> 

Gabriel
