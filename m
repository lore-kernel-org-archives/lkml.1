Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZCVUHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZCVUHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZCVUHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:07:38 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52493 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZCVUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:07:38 -0400
Date: Sun, 22 Mar 2009 21:09:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: e820.h fix various signedness issues in setup.c and e820.c
Message-ID: <20090322200937.GA5887@uranus.ravnborg.org>
References: <1237749831.5417.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237749831.5417.2.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 12:53:51AM +0530, Jaswinder Singh Rajput wrote:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 23 Mar 2009 00:27:11 +0530
> Subject: [PATCH] x86: e820.h fix various signedness issues in setup.c and e820.c
> 
> Impact: cleanup
> 
> This fixed various signedness issues in setup.c and e820.c:
> arch/x86/kernel/setup.c:455:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:455:53:    expected int *pnr_map
> arch/x86/kernel/setup.c:455:53:    got unsigned int extern [toplevel] *<noident>
> arch/x86/kernel/setup.c:639:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:639:53:    expected int *pnr_map
> arch/x86/kernel/setup.c:639:53:    got unsigned int extern [toplevel] *<noident>
> arch/x86/kernel/setup.c:820:54: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:820:54:    expected int *pnr_map
> arch/x86/kernel/setup.c:820:54:    got unsigned int extern [toplevel] *<noident>
> 
> arch/x86/kernel/e820.c:670:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/e820.c:670:53:    expected int *pnr_map
> arch/x86/kernel/e820.c:670:53:    got unsigned int [toplevel] *<noident>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/e820.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 00d41ce..a1e1c54 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -57,7 +57,7 @@ struct e820entry {
>  } __attribute__((packed));
>  
>  struct e820map {
> -	__u32 nr_map;
> +	int nr_map;
>  	struct e820entry map[E820_X_MAX];
>  };

but that header is exported so use of plain int looks wrong.

	Sam
