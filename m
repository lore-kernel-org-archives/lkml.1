Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbYKZIJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbYKZIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYKZIIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:08:50 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37565 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYKZIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:08:49 -0500
Date: Wed, 26 Nov 2008 09:08:46 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: core_param: call these really, really early.
Message-ID: <20081126080846.GA7168@osiris.boeblingen.de.ibm.com>
References: <200811200123.41353.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200123.41353.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:23:41AM +1030, Rusty Russell wrote:
> As soon as we have command line, so even before early_param.  They
> just set vars, so it makes sense to do them as early as possible.
> 
> This allows them to replace early_param, and fixes a bug in the new
> cpu_alloc implementation patches which was a complete PITA to find.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

[...]

> diff -r 65aebfe44ef1 init/main.c
> --- a/init/main.c	Wed Nov 19 22:47:52 2008 +1030
> +++ b/init/main.c	Wed Nov 19 23:58:08 2008 +1030
> @@ -569,6 +588,10 @@
>  	setup_arch(&command_line);
>  	mm_init_owner(&init_mm, &init_task);
>  	setup_command_line(command_line);
> +	parse_args("Core params", command_line, __start___core_param,
> +		   __stop___core_param - __start___core_param,
> +		   unknown_core_ok);
> +
>  	unwind_setup();
>  	setup_per_cpu_areas();
>  	setup_nr_cpu_ids();

...but setup_arch() calls parse_early_param(). So how is this earlier
than early_param?
