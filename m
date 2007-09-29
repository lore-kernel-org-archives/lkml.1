Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXI2JLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXI2JLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXI2JL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:11:28 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:35327 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXI2JL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:11:27 -0400
Date: Sat, 29 Sep 2007 11:11:24 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Generic compat_sys_fallocate
In-Reply-To: <1191018832-18069-2-git-send-email-kyle@mcmartin.ca>
Message-ID: <Pine.LNX.4.64.0709291109320.10965@anakin>
References: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
 <1191018832-18069-2-git-send-email-kyle@mcmartin.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Kyle McMartin wrote:
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -2226,3 +2226,13 @@ asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
>  }
>  
>  #endif /* CONFIG_TIMERFD */
> +
> +asmlinkage long compat_sys_fallocate(int fd, int mode,
> +				     u32 offset_lo, u32 offset_hi,
> +				     u32 len_lo, u32 len_hi)
> +{
> +	u64 offset = compat_merge64(offset_lo, offset_hi);
> +	u64 len = compat_merge64(len_lo, len_hi);
> +
> +	return sys_fallocate(fd, mode, offset, len);
> +}

To avoid confusion, you may want to rename the *_{lo,hi} parameters to
e.g. *_{l,r}, as they don't actually mean the low and high part anymore.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
