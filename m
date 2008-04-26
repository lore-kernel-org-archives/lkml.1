Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYDZQeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYDZQeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYDZQe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:34:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18484 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYDZQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:34:28 -0400
Date: Sat, 26 Apr 2008 18:34:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [fix] [git pull] VFS patches
Message-ID: <20080426183414.1acf7ed2@hyperion.delvare>
In-Reply-To: <20080426042459.GG5882@ZenIV.linux.org.uk>
References: <20080426020221.GF5882@ZenIV.linux.org.uk>
	<20080426042459.GG5882@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 05:25:00 +0100, Al Viro wrote:
> 	Arrgghhh...
> 
> Sorry about that, I'd been sure I'd folded that one, but it actually got
> lost.  Please apply - that breaks execve().
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4df3949..a647542 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1788,7 +1788,7 @@ bad_unshare_out:
>  int unshare_files(struct files_struct **displaced)
>  {
>  	struct task_struct *task = current;
> -	struct files_struct *copy;
> +	struct files_struct *copy = NULL;
>  	int error;
>  
>  	error = unshare_fd(CLONE_FILES, &copy);

This apparently prevents the general protection faults I was hitting
with 2.6.25-git8. Linus, please apply Al's fixup patch quickly, as it
will probably hit pretty much everyone trying it.

Thanks,
-- 
Jean Delvare
