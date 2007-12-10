Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXLJTa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXLJTa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXLJTaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:30:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55309 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbXLJTaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:30:13 -0500
Date: Mon, 10 Dec 2007 20:32:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH RFC] [5/9] modpost: Fix a buffer overflow in modpost
Message-ID: <20071210193202.GC17315@uranus.ravnborg.org>
References: <20071122343.446909000@suse.de> <20071122024310.BB7E414D68@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122024310.BB7E414D68@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 03:43:10AM +0100, Andi Kleen wrote:
> 
> When passing an file name > 1k the stack could be overflowed.
> Not really a security issue, but still better plugged.

Looks good. A s-o-b line again please.
Although I am not so happy with the ue of gcc extensions.

	Sam
> 
> 
> ---
>  scripts/mod/modpost.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/scripts/mod/modpost.c
> ===================================================================
> --- linux.orig/scripts/mod/modpost.c
> +++ linux/scripts/mod/modpost.c
> @@ -1656,7 +1656,6 @@ int main(int argc, char **argv)
>  {
>  	struct module *mod;
>  	struct buffer buf = { };
> -	char fname[SZ];
>  	char *kernel_read = NULL, *module_read = NULL;
>  	char *dump_write = NULL;
>  	int opt;
> @@ -1709,6 +1708,8 @@ int main(int argc, char **argv)
>  	err = 0;
>  
>  	for (mod = modules; mod; mod = mod->next) {
> +		char fname[strlen(mod->name) + 10];
> +
>  		if (mod->skip)
>  			continue;
>  
