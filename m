Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbZD0SqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbZD0SqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbZD0Spm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:45:42 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34122 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbZD0Spl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:45:41 -0400
Date: Mon, 27 Apr 2009 20:47:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 6/8] sh: Use __INIT macro instead of .text.init.
Message-ID: <20090427184750.GF12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu> <1240855347-19316-6-git-send-email-tabbott@mit.edu> <1240855347-19316-7-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-7-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:25PM -0400, Tim Abbott wrote:
> The sh architecture has some code in the .text.init section, but it
> does not reference that section in its linker scripts.
> 
> This change moves this code from the .text.init section to the
> .init.text section, which is presumably where it belongs.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  arch/sh/kernel/cpu/sh5/entry.S |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sh/kernel/cpu/sh5/entry.S b/arch/sh/kernel/cpu/sh5/entry.S
> index e640c63..7e49cb8 100644
> --- a/arch/sh/kernel/cpu/sh5/entry.S
> +++ b/arch/sh/kernel/cpu/sh5/entry.S
> @@ -10,6 +10,7 @@
>   * for more details.
>   */
>  #include <linux/errno.h>
> +#include <linux/init.h>
>  #include <linux/sys.h>
>  #include <cpu/registers.h>
>  #include <asm/processor.h>
> @@ -2058,10 +2059,10 @@ asm_uaccess_end:
>  
>  
>  /*
> - * --- .text.init Section
> + * --- .init.text Section
>   */
>  
> -	.section	.text.init, "ax"
> +	__INIT
>  
>  /*
>   * void trap_init (void)
> -- 
> 1.6.2.1
> 
