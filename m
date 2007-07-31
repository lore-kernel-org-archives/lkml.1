Return-Path: <linux-kernel-owner+w=401wt.eu-S934912AbXGaV6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912AbXGaV6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXGaV6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:58:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:43918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbXGaV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sADM0Za64wgRGMaNvkDFa4L6wvWQyC8dr1GafcHEkYLjUPiqs4eexPjlHsFilKu9y+rwgo6J4jIWR/yWUiSCSlKen+WwmavbsgpFLT0I44GnOayKZUK+4upreJkxauOhFH43v4pUkTdz/bTd7/rZRR2hDyDmya2td6tcSAb3Z2Q=
Message-ID: <46AFB06E.2020401@googlemail.com>
Date: Tue, 31 Jul 2007 23:58:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com> <20070731204846.GA9985@uranus.ravnborg.org>
In-Reply-To: <20070731204846.GA9985@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Jul 31, 2007 at 09:45:22PM +0200, Gabriel C wrote:
>> Hi Sam ,
>>
>> me again. I got some more mismatch warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-14 )
>>
>>
>> ...
>>
>>
>>   MODPOST vmlinux.o
>> WARNING: vmlinux.o(.text+0x8adb): Section mismatch: reference to .init.text:register_cpu (between 'arch_register_cpu' and 'text_poke')
>> WARNING: vmlinux.o(.text+0xb790c): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')
> They need further analysis.

< big snip >

> All the hda_preset stuff should be marked __devinit as far as I can see.
> Care to give that a spin yourself?

Yes.

I'm not sure I can do it today but tomorrow for sure.
 
> 
>> WARNING: vmlinux.o(.data+0xacb10): Section mismatch: reference to .init.text:snd_ad1889_probe (between 'ad1889_pci' and 'ops.20707')
>> WARNING: vmlinux.o(.text+0x12f014): Section mismatch: reference to .exit.text:mlx4_remove_one (between 'mlx4_restart_one' and 'mlx4_cleanup_mcg_table')
> Did not look at these two yet.
> 
>> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
>> WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
>> WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> When a function is marked __exit and used from an init function then the safe choice
> is to just remove the __exit marking. Usually this is small functions used
> only in error situations.
> Should be trivial too.

I'll look at those too

> 
> Sorry - no patch this time. Could you try to look at it yorself then I will review.

Ok I'll try.


> 
> 	Sam
> 

Gabriel
