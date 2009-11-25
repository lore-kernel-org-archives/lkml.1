Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZKYOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZKYOrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZKYOrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:47:15 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:41829 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZKYOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:47:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=K7CqyFEUa725JKtAV18p3FL3b878rBNyNE0KaEgfl7lTvmSd1d3QVL+S87WSXAGnwR
         Q9tBHX5ZM06YZMvimRsqRTkifSgga/4V7UoGP0/iYcPPX+7mnJndslZecaI48eZMxvSg
         cY0c4hk+vpsOgpUVxYlnTPp/btfoNrZruaIMI=
Date: Wed, 25 Nov 2009 22:51:33 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "viro" <viro@zeniv.linux.org.uk>, "akpm" <akpm@linux-foundation.org>,
       "jack" <jack@suse.cz>, "npiggin" <npiggin@suse.de>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>
References: <200911252209432039291@gmail.com>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <200911252251305001347@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAPElT16016570

Hi  Matthew Wilcox ,
    The code means set counter's value to the max max_reserved and counter.
Then, the if condition will choose a large one, and in the function, the counter
is increased. so this code won't change the function of iunique().

> + if (counter <= max_reserved)
> + counter = max_reserved + 1;


-----------
Best Regards,
Liuweni 
2009-11-25 







·¢¼şÈË£º Matthew Wilcox 
·¢ËÍÊ±¼ä£º 2009-11-25  22:15:09 
ÊÕ¼şÈË£º Liuweni 
³­ËÍ£º linux-kernel; strongzgy; xgr178; Liu Hui; viro; akpm; jack; npiggin; linux-fsdevel 
Ö÷Ìâ£º Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance 
 
On Wed, Nov 25, 2009 at 10:09:45PM +0800, Liuweni wrote:
> ---
> move the if condition out the while{}.
> While the function executing, the if 
> condition won't check again and again.
> And this code won't change the function
> of iunique().
That's not true.
> @@ -838,9 +838,10 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
>   ino_t res;
>  
>   spin_lock(&inode_lock);
> +
> + if (counter <= max_reserved)
> + counter = max_reserved + 1;
>   do {
> - if (counter <= max_reserved)
> - counter = max_reserved + 1;
>   res = counter++;
'counter' is incremented here, so if it wraps around, we'll blunder into 
the reserved space again.
>   head = inode_hashtable + hash(sb, res);
>   inode = find_inode_fast(sb, head, res);
> 
>   
> --------------
> Best Regards,
> Liuweni
> 2009-11-25
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Matthew Wilcox Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
