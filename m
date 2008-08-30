Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYH3Q2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYH3Q2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 12:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYH3Q2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 12:28:45 -0400
Received: from h155.mvista.com ([63.81.120.155]:33120 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752628AbYH3Q2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 12:28:44 -0400
Message-ID: <48B97557.8090907@ru.mvista.com>
Date: Sat, 30 Aug 2008 20:29:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
References: <20080829213217.4826.91622.stgit@denkblock.local>	<48B92CB6.2090702@ru.mvista.com> <48B92D7A.7020701@ru.mvista.com> <87wshympza.fsf@denkblock.local>
In-Reply-To: <87wshympza.fsf@denkblock.local>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:

>>>>Recent changes have broken compilation when CONFIG_IDE_PROC_FS is
>>>>not set.

>>>>Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

>>>[...]

>>>>diff --git a/drivers/ide/ide-disk.h b/drivers/ide/ide-disk.h
>>>>index f937772..5254cae 100644
>>>>--- a/drivers/ide/ide-disk.h
>>>>+++ b/drivers/ide/ide-disk.h
>>>>@@ -23,8 +23,10 @@ ide_decl_devset(acoustic);
>>>> /* ide-disk_ioctl.c */
>>>> int ide_disk_ioctl(struct inode *, struct file *, unsigned int,
>>>>unsigned long);
>>>> +#ifdef CONFIG_IDE_PROC_FS
>>>> /* ide-disk_proc.c */
>>>> extern ide_proc_entry_t ide_disk_proc[];
>>>> extern const struct ide_proc_devset ide_disk_settings[];
>>>>+#endif /* CONFIG_IDE_PROC_FS */
>>>>  #endif /* __IDE_DISK_H */

> [...]

>>>  Is surrounding 'extern' declarations by #ifdef's really of any value?
>>>  They shouldn't be used if CONFIG_IDE_PROC_FS=n, so no object file
>>>records should be generated.

>>  Ah, you probably mean to turn the possible link time errors if the
>>do get referenced into the compile time errors...

> Sorry, I don't quite understand that last sentence.

    If a variable declared 'extern' is referenced but the module containing 
its definition is not linked in, you get unresolved symbol at link time, if 
the declaration is missing altogether, you get error at compile time...

> But we definitely
> have compile time errors here because the compiler doesn't even know of
> ide_proc_entry_t when CONFIG_IDE_PROC_FS is not set. Therefore the
> forward declarations appear to be syntactically incorrect, regardless
> whether extern or not.

    Ah. I should've looked at the types of those variables, stupid/hasty me...

> Regards,

> Elias

MBR, Sergei
