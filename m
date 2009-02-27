Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZB0VoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZB0VoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZB0VoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:44:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbZB0VoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:44:07 -0500
Date: Fri, 27 Feb 2009 16:44:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Don't profile branches in arm's boot decompressor
Message-ID: <20090227214403.GD25589@goodmis.org>
References: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Uwe!



On Fri, Feb 27, 2009 at 10:09:43PM +0100, Uwe Kleine-K??nig wrote:
> This fixes many compile errors for arch/arm/boot/compressed/misc.c of
> the type:
> 
> 	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables
> 
> Fix was suggested by Steven Rostedt in #linux-rt.
> 
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> Cc: Steven Rostedt <rostedt@home.goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/arm/boot/compressed/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index fbe5eef..0bcc98c 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -89,7 +89,7 @@ LDFLAGS_vmlinux += -p --no-undefined -X \
>  
>  # Don't allow any static data in misc.o, which
>  # would otherwise mess up our GOT table
> -CFLAGS_misc.o := -Dstatic=
> +CFLAGS_misc.o := -Dstatic= -DDISABLE_BRANCH_PROFILING

Could you also add a comment saying something to the effect:

# The branch profiler requires static variables.
# No need to profile the boot up code, so simply disable it.

Thanks,

-- Steve

>  
>  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
>  	 	$(addprefix $(obj)/, $(OBJS)) FORCE
> -- 
> tg: (db50eec..) t/ftrace/fix-PROFILE_ALL_BRANCHES (depends on: tip/master)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
