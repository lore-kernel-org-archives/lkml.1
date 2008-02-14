Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbYBNDkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbYBNDkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYBNDkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:40:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277AbYBNDkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:40:04 -0500
Date: Wed, 13 Feb 2008 19:39:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adfs: trivial sparse fix
Message-Id: <20080213193945.91b42a8d.akpm@linux-foundation.org>
In-Reply-To: <1202954868.18204.47.camel@brick>
References: <1202954868.18204.47.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 18:07:48 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> fs/adfs/dir_f.c:126:4: warning: do-while statement is not a compound statement
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/adfs/dir_f.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/adfs/dir_f.c b/fs/adfs/dir_f.c
> index b9b2b27..ea7df21 100644
> --- a/fs/adfs/dir_f.c
> +++ b/fs/adfs/dir_f.c
> @@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir *dir)
>  		ptr.ptr8 = bufoff(bh, i);
>  		end.ptr8 = ptr.ptr8 + last - i;
>  
> -		do
> +		do {
>  			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
> -		while (ptr.ptr8 < end.ptr8);
> +		} while (ptr.ptr8 < end.ptr8);
>  	}
>  

eh?  It's sparse which needs fixing here, surely?
