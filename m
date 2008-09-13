Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYIMJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYIMJQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYIMJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:16:08 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:60272 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbYIMJQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:16:05 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Abdel Benamrouche <draconux@gmail.com>,
       Damien Lallement <dlallement@mandriva.com>,
       "pterjan@mandriva.com" <pterjan@mandriva.com>,
       Jens Axboe <axboe@kernel.dk>
Reply-To: 7eggert@gmx.de
Date: Sat, 13 Sep 2008 11:24:27 +0200
References: <bblSy-60j-19@gated-at.bofh.it> <bbnhC-7Vd-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KeRMh-0001Ay-Uj@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> +++ b/fs/partitions/check.c
> @@ -499,9 +499,9 @@ int rescan_partitions(struct gendisk *disk, struct
> block_device *bdev)
>  if (!size)
>  continue;
>  if (from + size > get_capacity(disk)) {
> -                     printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> +                     printk(KERN_WARNING
> +                             " %s: p%d exceeds device capacity"
                                ", trimmed\n",
>  disk->disk_name, p);

Add "size = get_capacity(disk) - from" here?
(Possibly using a cached value for get_capacity(disk)?)


