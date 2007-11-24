Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXKXS2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXKXS2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXKXS2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:28:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:41430 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXKXS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lBCpXBVYnUiE2nfjxsP0CE8L5qvDtSBGMuMGIcYkxyPXVbYonBbUWa7A70LKUvzk+CWwoe6RyJXo+7PRSzmbqwEVkJky9Qd6q8fNPUWwjm/86WOLG7LbHFdsYdPFJilYF2M4aAFk1ZgyWpEwQBOHvDIR1xDCCf2UxmXuRae9d6c=
Message-ID: <47486D31.3060303@googlemail.com>
Date: Sat, 24 Nov 2007 19:28:01 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Laurent Riffard <laurent.riffard@free.fr>, Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <4744A6F2.4030302@free.fr>	 <20071121144116.c932727b.akpm@linux-foundation.org>	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>	 <4746BB9D.2030508@suse.de>  <4747135C.60205@free.fr>	 <1195886569.3195.2.camel@localhost.localdomain> <47481FA6.9050506@free.fr>	 <1195910809.3195.5.camel@localhost.localdomain>	 <47486569.1040406@googlemail.com> <1195927446.3195.20.camel@localhost.localdomain> <474868B6.8040004@googlemail.com>
In-Reply-To: <474868B6.8040004@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> James Bottomley wrote:
>> On Sat, 2007-11-24 at 18:54 +0100, Gabriel C wrote:
>>> James Bottomley wrote:
>>>> On Sat, 2007-11-24 at 13:57 +0100, Laurent Riffard wrote:
>>>>> Le 24.11.2007 07:42, James Bottomley a écrit :
>>>>>> On Fri, 2007-11-23 at 18:52 +0100, Laurent Riffard wrote:
>>>>>>> Le 23.11.2007 12:38, Hannes Reinecke a écrit :
>>>>>>>> Hannes Reinecke wrote:
>>>>>>>>> Laurent Riffard wrote:
>>>>>>>>>> Le 21.11.2007 23:41, Andrew Morton a écrit :
>>>>>>>>>>> On Wed, 21 Nov 2007 22:45:22 +0100
>>>>>>>>>>> Laurent Riffard <laurent.riffard@free.fr> wrote:
>>>>>>>>>>>
>>>>>>>>>>>> Le 21.11.2007 05:45, Andrew Morton a écrit :
>>>>>>>>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
>>>>>>>>>>>> Hello, 
>>>>>>>>>>>>
>>>>>>>>>>>> My system hangs shortly after I logged in Gnome desktop. SysRq-W shows
>>>>>>>>>>>> that a bunch of task are blocked in "D" state, they seem to wait for
>>>>>>>>>>>> some I/O completion. I can try to hand-copy some data if requested.
>>>>>>>>>>>>
>>>>>>>>>>>> I found these messages in dmesg:
>>>>>>>>>>>>
>>>>>>>>>>>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1 
>>>>>>>>>>>> EXT3-fs: mounted filesystem with ordered data mode.
>>>>>>>>>>>> sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>>>>>>>>>> end_request: I/O error, dev sda, sector 16460
>>>>>>>>>>>> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
>>>>>>>>>>>> ReiserFS: sda7: using ordered data mode
>>>>>>>>>>>> --
>>>>>>>>>>>> ReiserFS: sda7: Using r5 hash to sort names
>>>>>>>>>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>>>>>>>>>> end_request: I/O error, dev sdb, sector 19632
>>>>>>>>>>>> sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
>>>>>>>>>>>> end_request: I/O error, dev sdb, sector 40037363
>>>>>>>>>>>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
>>>>>>>>>>>> lp0: using parport0 (interrupt-driven).
>>>>>>>>>>>>
>>>>>>>>>>>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% reproducible.
>>>>>>>>>>>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
>>>>>>>>>>>>
>>>>>>>>>>>> Maybe something is broken in pata_via driver ?
>>>>>>>>>>>>
>>>>>>>>>>> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
>>>>>>>>>>> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
>>>>>>>>>>> touch pata_via.c.
>>>>>>>>>> None of the above...
>>>>>>>>>>
>>>>>>>>>> I did a bisection, it spotted git-scsi-misc.patch. 
>>>>>>>>>> I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it works fine.
>>>>>>>>>>
>>>>>>>>>> I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI] Do not 
>>>>>>>>>> requeue requests if REQ_FAILFAST is set" is the real culprit. The other 
>>>>>>>>>> commits are touching documentation or drivers I don't use. I'll try 
>>>>>>>>>> to revert only this one this evening.
>>>>>>> I can confirm : reverting commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 
>>>>>>> does fix the problem.
>>>>>>>
>>>>>>>>> Hmm. Weird. I'll have a look into it. Apparently I'll be returning an error where
>>>>>>>>> I shouldn't. Checking ...
>>>>>>>>>
>>>>>>>> Ok, found it. We are blocking even special commands (ie requests with PREEMPT not set)
>>>>>>>> when FAILFAST is set. Which is clearly wrong. The attached patch fixes this.
>>>>>>> Sorry, it's not enough. 2.6.24-rc3-mm1 + your patch still hangs with I/O errors.
>>>>>> I think the problem is the way we treat BLOCKED and QUIESCED (the latter
>>>>>> is the state that the domain validation uses and which we cannot kill
>>>>>> fastfail on).  It's definitely wrong to kill fastfail requests when the
>>>>>> state is QUIESCE.
>>>>>>
>>>>>> This patch (which is applied on top of Hannes original) separates the
>>>>>> BLOCK and QUIESCE states correctly ... does this fix the problem?
>>>>> No, it doesn't help... (2.6.24-rc3-mm1 + your patch still has problems)
>>>> OK, could you post dmesgs again, please.  I actually tested this with an
>>>> aic79xx card, and for me it does cause Domain Validation to succeed
>>>> again.
>>>>
>>> Are the patches indeed to fix that problem as well ? 
>>>
>>> http://lkml.org/lkml/2007/11/23/5
>> That dmesg is from an unknown SCSI card exhibiting Domain Validation
>> problems, so it's a reasonable probability, yes ... but you'll need the
>> additional hack I just did to prevent further intermittent failures.
> 
> My controller is:
> 
> 03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m [9005:008f] (rev 02)
> 
> I'll try the patches in a bit.

With your patches my problem(s) are solved. Domain Validation works again.

...

[   32.179521] scsi 0:0:0:0: Direct-Access     SEAGATE  ST318406LW       0109 PQ: 0 ANSI: 3
[   32.179540] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   32.179554]  target0:0:0: Beginning Domain Validation
[   32.188553]  target0:0:0: wide asynchronous
[   32.195302]  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   32.206510]  target0:0:0: Ending Domain Validation
[   32.211699] scsi 0:0:1:0: Direct-Access     FUJITSU  MAH3182MP        0114 PQ: 0 ANSI: 4
[   32.211707] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   32.211717]  target0:0:1: Beginning Domain Validation
[   32.213980]  target0:0:1: wide asynchronous
[   32.215682]  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   32.220205]  target0:0:1: Ending Domain Validation

...

 Thx James :)


Gabriel

