Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZBNVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZBNVx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBNVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:53:19 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55626 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZBNVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:53:18 -0500
Date: Sat, 14 Feb 2009 16:53:11 -0500
From: Andres Salomon <dilinger@queued.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Ball <cjb@laptop.org>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix model detection without OFW
Message-ID: <20090214165311.5cf5b8bf@ephemeral>
In-Reply-To: <20090214214312.GB31928@elte.hu>
References: <1222208409.16003.25.camel@brick>
	<m3mycpye65.fsf@pullcord.laptop.org>
	<20090213231900.4f22008a@ephemeral>
	<20090214214312.GB31928@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 22:43:12 +0100
Ingo Molnar <mingo@elte.hu> wrote:
[...]
> 
> Applied to tip:x86/urgent [for v2.6.29], thanks guys!
> 
> Did i get the impact-line below right?
> 
> 	Ingo
> 

More like -

Impact: garbled display, laptop is unusable

;)

The DCON detection code determines whether there's a DCON attached
based upon the model (any XO model >= B2 is assumed to have a DCON).
The LXFB driver determines which mode to use based upon whether or not
it thinks there's a DCON attached, and the DCON/LXFB can't deal w/
standard modes.

So, the result is that LXFB attempts to use some random standard mode
rather than the DCON-required 1200x900, and the display is unusable.



> ---------------->
> From 307250cda516547c0b0fe70dc3a3626bd82820cc Mon Sep 17 00:00:00 2001
> From: Chris Ball <cjb@laptop.org>
> Date: Fri, 13 Feb 2009 20:56:18 -0500
> Subject: [PATCH] x86, olpc: fix model detection without OFW
> 
> Impact: make certain OLPC-board revision based quirks [mouse, sound]
> work properly
> 
> Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)
> breaks model comparison on OLPC; the value 0xc2 needs to be scaled
> up by olpc_board().  The pre-patch version was wrong, but accidentally
> worked anyway (big-endian 0xc2 is big enough to satisfy all other
> board revisions, but little endian 0xc2 is not).
> 
> Signed-off-by: Chris Ball <cjb@laptop.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Andres Salomon <dilinger@queued.net>
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/olpc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 7a13fac..4006c52 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -203,7 +203,7 @@ static void __init platform_detect(void)
>  static void __init platform_detect(void)
>  {
>  	/* stopgap until OFW support is added to the kernel */
> -	olpc_platform_info.boardrev = 0xc2;
> +	olpc_platform_info.boardrev = olpc_board(0xc2);
>  }
>  #endif
>  
