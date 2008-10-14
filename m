Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYJNI0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYJNI0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYJNI0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:26:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:57547 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJNI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=akqxRfmzGj3WHku5sbzl2gLrZPxaM8Wrgjz7tBv5Qh4EjRD2t3OUUqbJ/alNSM7VTV
         bCcxk+JAfPJk64U5r2R31J3c9NnizRkf8z2JgL/GQ+ga8OmnxM08USi6oNKV/0nlycDR
         i52Deqi6c3ONLxX8G9y7/9xaWkPmcyWeZ+C0k=
Message-ID: <9ea470500810140126v3058d99dn47768834bd087111@mail.gmail.com>
Date: Tue, 14 Oct 2008 10:26:19 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: New CD/DVD reports 'Can Play Audio NO'
Cc: "Nick Warne" <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       "D Bray" <db1986@internetdog.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <48F441F0.90408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081004103355.407fc303@sauron.linicks.net>
	 <48E82FDB.6020009@kernel.org>
	 <20081005120809.38eb4826@sauron.linicks.net>
	 <48F441F0.90408@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 8:53 AM, Tejun Heo <tj@kernel.org> wrote:
> Nick Warne wrote:
>> /messages
>> Oct  5 11:54:13 sauron kernel: ata5: PATA max UDMA/133 cmd 0x1f0 ctl
>> 0x3f6 bmdma 0xf400 irq 14
>> Oct  5 11:54:13 sauron kernel: ata6: PATA max
>> UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf408 irq 15
>> Oct  5 11:54:13 sauron kernel: ata5.00: ATAPI: TSSTcorp CDDVDW
>> SH-S202J, SB00, max UDMA/66
>> Oct  5 11:54:13 sauron kernel: ata5.01: ATAPI: Optiarc DVD RW AD-7200A,
>> 1.06, max UDMA/66
>> Oct  5 11:54:13 sauron kernel: ata5.00: configured for UDMA/66
>> Oct  5 11:54:13 sauron kernel: ata5.01: configured for
>> UDMA/66
>>
>> /syslog
>> Oct  5 11:54:13 sauron kernel: sr0: scsi3-mmc drive: 48x/48x writer
>> dvd-ram cd/rw xa/form2 cdda tray
>> Oct  5 11:54:13 sauron kernel: sr1:
>> scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
>>
>> /proc/sys/dev/cdrom/info
>>
>> drive name:             sr1     sr0
>> drive speed:            48      48
>> drive # of slots:       1       1
>> Can close tray:         1       1
>> Can open tray:          1       1
>> Can lock tray:          1       1
>> Can change speed:       1       1
>> Can select disk:        0       0
>> Can read multisession:  1       1
>> Can read MCN:           1       1
>> Reports media changed:  1       1
>> Can play audio:         1       1
>> Can write CD-R:         1       1
>> Can write CD-RW:        1       1
>> Can read DVD:           1       1
>> Can write DVD-R:        1       1
>> Can write DVD-RAM:      1       1
>> Can read MRW:           1       1
>> Can write MRW:          1       1
>> Can write RAM:          1       1
>
> Thanks.  sr.c just doesn't check whether the drive reports audio play
> capability or not.  It just sets it while ide-cd actually checks for
> the capability.  The drive is not reporting it while it can so ide-cd
> needs blacklist entry for it.  Now that idecd has blacklist entry, all
> should be fine.  Eh... I'm not sure whether we need to update sr to
> follow what ide-cd is doing or not.
>
> Thanks.

Actually, as I already pointed out, I'm not at all happy with blacklisting
stuff. What sounds more sane to me (and this is only me) would be what sr.c
does: assume that per se the drive can play audio and try to play it. But how
many drives are there that cannot play audio, aka, would it be a safe assumption
to say that their number is so diminishingly small that it would be better to
announce that a drive can play audio by default and fail graciously in the
_very_ seldom case it actually cannot ...

-- 
Regards/Gruss,
Boris
