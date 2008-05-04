Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYEDKlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYEDKlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYEDKk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:40:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49545 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYEDKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:40:54 -0400
Message-ID: <481D9247.4010804@cs.helsinki.fi>
Date: Sun, 04 May 2008 13:39:03 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Eric Youngdale <ericy@cais.com>,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] fs/binfmt_elf.c: fix a wrong free
References: <20080503124610.GA3986@hack> <Pine.LNX.4.64.0805031625150.20470@sbz-30.cs.Helsinki.FI> <20080503143942.GE3986@hack>
In-Reply-To: <20080503143942.GE3986@hack>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> Hi, Pekka!
> 
> Thanks for your comments. Yes, it seems that fill_note_info() is ugly.
> :-) How about the below one?
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> 
> ---
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index f6d5a9d..357b503 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1900,7 +1900,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>  	/* alloc memory for large data structures: too large to be on stack */
>  	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
>  	if (!elf)
> -		goto cleanup;
> +		goto ret;
>  	
>  	segs = current->mm->map_count;
>  #ifdef ELF_CORE_EXTRA_PHDRS
> @@ -2034,8 +2034,9 @@ end_coredump:
>  	set_fs(fs);
>  
>  cleanup:
> -	kfree(elf);
>  	free_note_info(&info);
> +	kfree(elf);
> +ret:
>  	return has_dumped;

Looks good although 'ret' is usually reserved for the variable that 
contains the return value so you might want to consider using the more 
idiomatic 'out' as the label name.

		Pekka
