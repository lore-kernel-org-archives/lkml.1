Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0CAQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:56:25 -0500
Received: from xenotime.net ([72.52.64.118]:49473 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751264Ab0CAQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:56:24 -0500
Message-ID: <4B8BF1B4.7040502@xenotime.net>
Date: Mon, 01 Mar 2010 08:56:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 25 (quota)
References: <20100225183523.80361261.sfr@canb.auug.org.au> <4B86B1A3.2090606@xenotime.net> <20100301132752.GG3271@quack.suse.cz>
In-Reply-To: <20100301132752.GG3271@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/10 05:27, Jan Kara wrote:
> On Thu 25-02-10 09:21:39, Randy Dunlap wrote:
>> On 02/24/10 23:35, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20100224:
>>
>>
>> When CONFIG_BLOCK=n:
>>
>> fs/quota/dquot.c:2042: error: implicit declaration of function 'fsync_bdev'
>   Thanks for notification. I've fixed this by the following patch:
> 
> From 9007983e9bf994200194727bcb87d45bb924b4a8 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 1 Mar 2010 14:24:36 +0100
> Subject: [PATCH] vfs: Provide empty fsync_bdev if !CONFIG_BLOCK
> 
> Provide empty declaration of fsync_bdev when CONFIG_BLOCK is not defined so
> that quota code can use it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/fs.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ebb1cd5..b9e4f1c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1961,6 +1961,11 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
>  	return 0;
>  }
> +
> +static inline int fsync_bdev(struct block_device *bdev)
> +{
> +	return 0;
> +}
>  #endif
>  extern int sync_filesystem(struct super_block *);
>  extern const struct file_operations def_blk_fops;

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.
-- 
~Randy
