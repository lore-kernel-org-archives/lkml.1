Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZAYLNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZAYLNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAYLNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:13:24 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:47801 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZAYLNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JfX2ssXd01EbbV7Lvf48QGX0p8sOp4OHa63W1dSeb6m5PymlFHfct/9WXgzAaD9rSx
         ZpV5NiPZu33DvWO6XPaCwBi+zP9YkyxPSGKqwoN/CDxaRGXRAitXYVbT60IDOB5Qp3IU
         q12+ECpEI3Qz9mKjMlmQfz6G/BBAoj468eYr4=
Date: Sun, 25 Jan 2009 14:18:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: add sys_* entries for syscalls in tags
Message-ID: <20090125111856.GA3268@x200.localdomain>
References: <20090125100553.GA18239@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125100553.GA18239@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 03:35:54PM +0530, Rabin Vincent wrote:
> Currently, it is no longer possible to use the tags file to jump to
> system call function definitions with sys_foo because the definitions
> are obscured by the use of the SYSCALL_DEFINE* macros.
> 
> This patch adds the appropriate option to ctags to make it see through
> the macro.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/tags.sh |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index fdbe78b..0d58f48 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -99,7 +99,8 @@ exuberant()
>  	-I ____cacheline_internodealigned_in_smp                \
>  	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
>  	--extra=+f --c-kinds=+px                                \
> -	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'
> +	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
> +	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'

You should patch emacs() as well.
