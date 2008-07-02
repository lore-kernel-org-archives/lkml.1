Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYGBGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYGBGSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYGBGSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:18:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbYGBGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:18:06 -0400
Date: Tue, 1 Jul 2008 23:17:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <sam@ravnborg.org>, <stable@kernel.org>, <llipavsky@suse.cz>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] move __attribute__((__cold__)) functions back into
 final .text section
Message-Id: <20080701231717.047d580a.akpm@linux-foundation.org>
In-Reply-To: <48590F41.76E4.0078.0@novell.com>
References: <48590F41.76E4.0078.0@novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 12:36:01 +0100 "Jan Beulich" <jbeulich@novell.com> wrote:

> Due to the addition of __attribute__((__cold__)) to a few symbols
> without adjusting the linker scripts, those symbols currently may end
> up outside the [_stext,_etext) range, as they get placed in
> .text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
> outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
> Hence we need to add .text.unlikely (and for future uses of
> __attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.
> 
> Issue observed by Lukas Lipavsky.
> 
> Cc: Lukas Lipavsky <llipavsky@suse.cz>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  include/asm-generic/vmlinux.lds.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.26-rc6/include/asm-generic/vmlinux.lds.h	2008-04-17 04:49:44.000000000 +0200
> +++ 2.6.26-rc6-hot-cold-text/include/asm-generic/vmlinux.lds.h	2008-06-18 12:19:22.000000000 +0200
> @@ -204,6 +204,7 @@
>   * during second ld run in second ld pass when generating System.map */
>  #define TEXT_TEXT							\
>  		ALIGN_FUNCTION();					\
> +		*(.text.hot)						\
>  		*(.text)						\
>  		*(.ref.text)						\
>  		*(.text.init.refok)					\
> @@ -213,7 +214,8 @@
>  	CPU_KEEP(init.text)						\
>  	CPU_KEEP(exit.text)						\
>  	MEM_KEEP(init.text)						\
> -	MEM_KEEP(exit.text)
> +	MEM_KEEP(exit.text)						\
> +		*(.text.unlikely)
>  
>  
>  /* sched.text is aling to function alignment to secure we have same
> 

So this is now in Sam's
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git.
But it is not in the present linux-next.  Either because Sam added it
after Stephen pulled Sam's tree, or because something screwed up.

So I'll now be dropping it.  Sam, please ensure that it gets into
2.6.26 and 2.6.25.x (IMO).

Thanks.

