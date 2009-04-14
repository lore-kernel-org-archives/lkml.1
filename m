Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZDNHoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZDNHoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZDNHoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:44:07 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56905 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZDNHoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IvD6jjo8ZltAMAVQErnsuyua+8Lei5BwsTsrWRRT1+5lhI/lWIa0hq94MQqF2Byaay
         tZ3RLjDyj0MECrKzOCtfZhDtctywCHbKiQfJgehsfJi/gzAFU+w8TgwPemFqIrQCNq5v
         +fpXVSZTPM0sFYUJpflpAbNyK1cscUYbyF+qc=
MIME-Version: 1.0
In-Reply-To: <20090414073631.GA4145@localhost.localdomain>
References: <20090414073631.GA4145@localhost.localdomain>
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Tue, 14 Apr 2009 13:13:49 +0530
Message-ID: <ea11fea30904140043y1f2e4200oe225a6e2b2a88712@mail.gmail.com>
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 1:06 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> Add missing mutex_unlock in error path in ext2_quota_write()

This has already been taken I think.

http://patchwork.ozlabs.org/patch/25661/

Thanks -
Manish


>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index f983225..5c4afe6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1395,8 +1395,10 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
>                blk++;
>        }
>  out:
> -       if (len == towrite)
> +       if (len == towrite) {
> +               mutex_unlock(&inode->i_mutex);
>                return err;
> +       }
>        if (inode->i_size < off+len-towrite)
>                i_size_write(inode, off+len-towrite);
>        inode->i_version++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks -
Manish
