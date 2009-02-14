Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZBNETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZBNETS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZBNETJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:19:09 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:39213 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZBNETI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:19:08 -0500
Date: Fri, 13 Feb 2009 23:19:00 -0500
From: Andres Salomon <dilinger@queued.net>
To: Chris Ball <cjb@laptop.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix model detection without OFW
Message-ID: <20090213231900.4f22008a@ephemeral>
In-Reply-To: <m3mycpye65.fsf@pullcord.laptop.org>
References: <1222208409.16003.25.camel@brick>
	<m3mycpye65.fsf@pullcord.laptop.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed on IRC, this has the Dilinger Seal Of Approval (tm).

Acked-by: Andres Salomon <dilinger@debian.org>



On Fri, 13 Feb 2009 20:56:18 -0500
Chris Ball <cjb@laptop.org> wrote:

> Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)
> breaks model comparison on OLPC; the value 0xc2 needs to be scaled
> up by olpc_board().  The pre-patch version was wrong, but accidentally
> worked anyway (big-endian 0xc2 is big enough to satisfy all other
> board revisions, but little endian 0xc2 is not).
> 
> Signed-off-by: Chris Ball <cjb@laptop.org>
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
