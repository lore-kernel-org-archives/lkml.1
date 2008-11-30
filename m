Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYK3AhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYK3AhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 19:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYK3AhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 19:37:10 -0500
Received: from main.gmane.org ([80.91.229.2]:39110 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYK3AhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 19:37:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] ext4: fix loop in do_split()
Date: Sat, 29 Nov 2008 19:36:52 -0500
Message-ID: <4931E024.2010500@tmr.com>
References: <49310D34.1000205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-ext4@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081112 Fedora/1.1.13-1.fc9 SeaMonkey/1.1.13
In-Reply-To: <49310D34.1000205@gmail.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> unsigned i >= 0 is always true
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 63adcb7..389cf60 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count-1; i < count; i--) {
>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;
> 
While this unsigned wrap method is technically valid, it certainly isn't 
obvious, and making code readable should be a goal as well as making it correct. 
  After all, code which is hard to read is hard to understand, making it hard to 
maintain. I therefore suggest the simpler form:
	for (i = count; i--; ) {
which gives the same i values inside the loop, but does assume that the reader 
remembers that i is unsigned, and intuitively understand wraparound while 
passing zero.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

