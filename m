Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZDZLOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZDZLOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZDZLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:14:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52347 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZDZLOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:14:23 -0400
Date: Sun, 26 Apr 2009 13:16:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/15] frv: convert frv to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426111632.GC28642@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240711870-30505-4-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:10:59PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name use for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David Howells <dhowells@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/frv/kernel/head.S        |    3 ++-
>  arch/frv/kernel/vmlinux.lds.S |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/frv/kernel/head.S b/arch/frv/kernel/head.S
> index fecf751..b825ef3 100644
> --- a/arch/frv/kernel/head.S
> +++ b/arch/frv/kernel/head.S
> @@ -9,6 +9,7 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> +#include <linux/init.h>
>  #include <linux/threads.h>
>  #include <linux/linkage.h>
>  #include <asm/thread_info.h>
> @@ -27,7 +28,7 @@
>  #   command line string
>  #
>  ###############################################################################
> -	.section	.text.head,"ax"
> +	__HEAD
>  	.balign		4
>  
>  	.globl		_boot, __head_reference
> diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
> index b95c4ea..22d9787 100644
> --- a/arch/frv/kernel/vmlinux.lds.S
> +++ b/arch/frv/kernel/vmlinux.lds.S
> @@ -26,7 +26,7 @@ SECTIONS
>  
>    _sinittext = .;
>    .init.text : {
> -	*(.text.head)
> +	HEAD_TEXT
>  #ifndef CONFIG_DEBUG_INFO
>  	INIT_TEXT
>  	EXIT_TEXT
> -- 
> 1.6.2.1
> 
