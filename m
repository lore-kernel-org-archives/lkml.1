Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYJ0UcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYJ0UcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYJ0UcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:32:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbYJ0UcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:32:08 -0400
Date: Mon, 27 Oct 2008 13:31:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
Subject: Re: [PATCH 2/6] autofs4 - remove string terminator check
Message-Id: <20081027133131.f2011d28.akpm@linux-foundation.org>
In-Reply-To: <20081023023522.4508.27987.stgit@raven.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	<20081023023522.4508.27987.stgit@raven.themaw.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 10:35:22 +0800
Ian Kent <raven@themaw.net> wrote:

> Remove unnecessary string terminator check.

Why is it unnecessary?

Does this change alter behaviour in any way?

Does it fix a bug?

Better changelogs, please....

> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -51,18 +51,6 @@ static int check_name(const char *name)
>  }
>  
>  /*
> - * Check a string doesn't overrun the chunk of
> - * memory we copied from user land.
> - */
> -static int invalid_str(char *str, void *end)
> -{
> -	while ((void *) str <= end)
> -		if (!*str++)
> -			return 0;
> -	return -EINVAL;
> -}
> -
> -/*
>   * Check that the user compiled against correct version of autofs
>   * misc device code.
>   *
> @@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
>  				    cmd);
>  			goto out;
>  		}
> -
> -		err = invalid_str(param->path,
> -				 (void *) ((size_t) param + param->size));
> -		if (err) {
> -			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> -				    cmd);
> -			goto out;
> -		}
>  	}
>  
>  	err = 0;
