Return-Path: <linux-kernel-owner+w=401wt.eu-S1765990AbXFFCss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765990AbXFFCss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 22:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXFFCsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 22:48:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbXFFCsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 22:48:39 -0400
Date: Tue, 5 Jun 2007 19:48:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] neaten lguest boot code (again)
Message-Id: <20070605194829.a295e20d.akpm@linux-foundation.org>
In-Reply-To: <1181097459.14054.100.camel@localhost.localdomain>
References: <1181097459.14054.100.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 12:37:39 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> (This cleanup seems to have gotten lost in rc3-mm1?  It was in rc2-mm1
> called lguest-the-host-code-update-for-mm-simplify-boot_params.patch)
> 
> Andrew patched up lguest after the boot parameters became a proper
> structure, but in fact it can be considerably neatened.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/lguest/lguest.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> ===================================================================
> --- a/drivers/lguest/lguest.c
> +++ b/drivers/lguest/lguest.c
> @@ -444,8 +444,7 @@ __init void lguest_init(void *boot)
>  {
>  	/* Copy boot parameters first. */
>  	memcpy(&boot_params, boot, PARAM_SIZE);
> -	memcpy(boot_command_line,
> -	       __va(*(unsigned long *)((void *)&boot_params + NEW_CL_POINTER)),
> +	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
>  	       COMMAND_LINE_SIZE);
>  
>  	paravirt_ops.name = "lguest";

I dropped it because it depended upon mm-simplify-boot_params.patch which
for some reason disappeared but now appears to have reappeared.

Shall resurrect.
