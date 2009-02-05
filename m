Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZBEDnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZBEDnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZBEDnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:43:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbZBEDnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:43:24 -0500
Date: Wed, 4 Feb 2009 19:43:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
       adobriyan@gmail.com, ebierderm@xmission.com, stable@kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Separate FMODE_PREAD/FMODE_PWRITE into separate flags
Message-Id: <20090204194310.1d5e96ae.akpm@linux-foundation.org>
In-Reply-To: <20090204194203.a2c652d2.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
	<20090204193615.2d9aaa7a.akpm@linux-foundation.org>
	<20090204194203.a2c652d2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 19:42:03 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> And I updated seq_file-properly-cope-with-pread.patch thusly:
> 
> --- a/fs/seq_file.c~seq_file-properly-cope-with-pread-fix
> +++ a/fs/seq_file.c
> @@ -48,6 +48,16 @@ int seq_open(struct file *file, const st
>  	 */
>  	file->f_version = 0;
>  
> +	/*
> +	 * seq_files support lseek() and pread().  They do not implement
> +	 * write() at all, but we clear FMODE_PWRITE here for historical
> +	 * reasons.
> +	 *
> +	 * If a client of seq_files a) implements file.write() and b) wishes to
> +	 * support pwrite() then that client will need to implement its own
> +	 * file.open() which calls seq_open() and then sets FMODE_WRITE.
                                                                  ^P
> +	 */
> +	file->f_mode &= ~FMODE_PWRITE;
>  	return 0;
>  }
>  EXPORT_SYMBOL(seq_open);
