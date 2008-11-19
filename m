Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKSAhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKSAhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYKSAgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:36:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYKSAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:36:53 -0500
Date: Tue, 18 Nov 2008 16:36:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, qhfeng.kernel@gmail.com
Subject: Re: [PATCH] fs/binfmt_misc.c: let binfmt status be more readable
Message-Id: <20081118163620.de14c1ec.akpm@linux-foundation.org>
In-Reply-To: <49211f7b.09876e0a.012d.079f@mx.google.com>
References: <49211f7b.09876e0a.012d.079f@mx.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 15:38:16 +0800
Qinghuang Feng <qhfeng.kernel@gmail.com> wrote:

> The following is what it looks like before patching.
> It is not much readable.
> 
> user@ubuntu:/proc/sys/fs/binfmt_misc$ cat status 
> enableduser@ubuntu:/proc/sys/fs/binfmt_misc$
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index f2744ab..72e8b24 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -652,7 +652,7 @@ static const struct file_operations bm_register_operations = {
>  static ssize_t
>  bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  {
> -	char *s = enabled ? "enabled" : "disabled";
> +	char *s = enabled ? "enabled\n" : "disabled\n";
>  
>  	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
>  }

Well.  That's a bugfix, really.

It fixes a bug which has been there for a very long time, in a way
which is non-backward-compatible.

Are there existing applications out there which will disastrously fail
if we add a newline to the /proc/sys/fs/binfmt_misc/status contents?  I
somehow doubt it.  But we shall find out :)



