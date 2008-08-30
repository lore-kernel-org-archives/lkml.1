Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYH3LTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYH3LTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYH3LT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:19:26 -0400
Received: from h155.mvista.com ([63.81.120.155]:30547 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017AbYH3LTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:19:25 -0400
Message-ID: <48B92CB6.2090702@ru.mvista.com>
Date: Sat, 30 Aug 2008 15:19:18 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
References: <20080829213217.4826.91622.stgit@denkblock.local>
In-Reply-To: <20080829213217.4826.91622.stgit@denkblock.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Elias Oltmanns wrote:
> Recent changes have broken compilation when CONFIG_IDE_PROC_FS is not set.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>   
[...]
> diff --git a/drivers/ide/ide-disk.h b/drivers/ide/ide-disk.h
> index f937772..5254cae 100644
> --- a/drivers/ide/ide-disk.h
> +++ b/drivers/ide/ide-disk.h
> @@ -23,8 +23,10 @@ ide_decl_devset(acoustic);
>  /* ide-disk_ioctl.c */
>  int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
>  
> +#ifdef CONFIG_IDE_PROC_FS
>  /* ide-disk_proc.c */
>  extern ide_proc_entry_t ide_disk_proc[];
>  extern const struct ide_proc_devset ide_disk_settings[];
> +#endif /* CONFIG_IDE_PROC_FS */
>  
>  #endif /* __IDE_DISK_H */
> diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
> index 2ad373e..86ee37e 100644
> --- a/drivers/ide/ide-floppy.h
> +++ b/drivers/ide/ide-floppy.h
> @@ -53,8 +53,10 @@ sector_t ide_floppy_capacity(ide_drive_t *);
>  /* ide-floppy_ioctl.c */
>  int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
>  
> +#ifdef CONFIG_IDE_PROC_FS
>  /* ide-floppy_proc.c */
>  extern ide_proc_entry_t ide_floppy_proc[];
>  extern const struct ide_proc_devset ide_floppy_settings[];
> +#endif /* CONFIG_IDE_PROC_FS */
>   

   Is surrounding 'extern' declarations by #ifdef's really of any value?
   They shouldn't be used if CONFIG_IDE_PROC_FS=n, so no object file 
records should be generated.

WBR, Sergei


