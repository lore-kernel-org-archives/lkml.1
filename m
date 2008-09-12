Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYILU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYILU2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYILU14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:27:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:49009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbYILU1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BGjInkkLyoVaMUMZaq9+yaXall2Xf44Wp7H4UwnmxgeiqE7yjmbAOYeBBz3WkztHqn
         Fu0wFDBO/tebmb9pQey1Q88EAp6LM39VC935goyYPi83fzoHRGiOWaPlbP6rxVcg+hov
         CyBARVDukNcHqeimo0RQ4lzJci8tfR+Riu39k=
Message-ID: <b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
Date: Fri, 12 Sep 2008 16:27:54 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "Abdel Benamrouche" <draconux@gmail.com>,
       "Damien Lallement" <dlallement@mandriva.com>,
       "pterjan@mandriva.com" <pterjan@mandriva.com>,
       "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <200809121714.05443.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	 <200809121714.05443.herton@mandriva.com.br>
X-Google-Sender-Auth: 609fb0860290d76d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 4:14 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 7d6b34e..15c70df 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -499,9 +499,9 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>                if (!size)
>                        continue;
>                if (from + size > get_capacity(disk)) {
> -                       printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> +                       printk(KERN_WARNING
> +                               " %s: p%d exceeds device capacity\n",
>                                disk->disk_name, p);
> -                       continue;

It might make sense to comment here that we intentionally want to add the
partition anyway.  That might keep someone from re-adding the continue (same
patch has already come up at least 3 times).

-- 
Bob Copeland %% www.bobcopeland.com
