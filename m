Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYH3QXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYH3QXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYH3QXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 12:23:34 -0400
Received: from nebensachen.de ([195.34.83.29]:41867 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYH3QXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 12:23:33 -0400
X-Hashcash: 1:20:080830:sshtylyov@ru.mvista.com::A5FGY6BgX1FeCoqO:000000000000000000000000000000000000003RYe
X-Hashcash: 1:20:080830:bzolnier@gmail.com::gEDQSdJX2nsatCmQ:00000000000000000000000000000000000000000001dr8
X-Hashcash: 1:20:080830:linux-ide@vger.kernel.org::NdXX+0x6g8jC4x4d:0000000000000000000000000000000000003h1D
X-Hashcash: 1:20:080830:linux-kernel@vger.kernel.org::pUK6Fpd3DinykVMR:0000000000000000000000000000000001+2c
From: Elias Oltmanns <eo@nebensachen.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
References: <20080829213217.4826.91622.stgit@denkblock.local>
	<48B92CB6.2090702@ru.mvista.com> <48B92D7A.7020701@ru.mvista.com>
Date: Sat, 30 Aug 2008 18:23:21 +0200
In-Reply-To: <48B92D7A.7020701@ru.mvista.com> (Sergei Shtylyov's message of
	"Sat, 30 Aug 2008 15:22:34 +0400")
Message-ID: <87wshympza.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Hello, I have just written:
>>> Recent changes have broken compilation when CONFIG_IDE_PROC_FS is
>
>>> not set.
>>>
>>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>>>   
>> [...]
>>> diff --git a/drivers/ide/ide-disk.h b/drivers/ide/ide-disk.h
>>> index f937772..5254cae 100644
>>> --- a/drivers/ide/ide-disk.h
>>> +++ b/drivers/ide/ide-disk.h
>>> @@ -23,8 +23,10 @@ ide_decl_devset(acoustic);
>>>  /* ide-disk_ioctl.c */
>>>  int ide_disk_ioctl(struct inode *, struct file *, unsigned int,
>>> unsigned long);
>>>  +#ifdef CONFIG_IDE_PROC_FS
>>>  /* ide-disk_proc.c */
>>>  extern ide_proc_entry_t ide_disk_proc[];
>>>  extern const struct ide_proc_devset ide_disk_settings[];
>>> +#endif /* CONFIG_IDE_PROC_FS */
>>>   #endif /* __IDE_DISK_H */
[...]
>>
>>   Is surrounding 'extern' declarations by #ifdef's really of any value?
>>   They shouldn't be used if CONFIG_IDE_PROC_FS=n, so no object file
>> records should be generated.
>
>   Ah, you probably mean to turn the possible link time errors if the
> do get referenced into the compile time errors...

Sorry, I don't quite understand that last sentence. But we definitely
have compile time errors here because the compiler doesn't even know of
ide_proc_entry_t when CONFIG_IDE_PROC_FS is not set. Therefore the
forward declarations appear to be syntactically incorrect, regardless
whether extern or not.

Regards,

Elias
