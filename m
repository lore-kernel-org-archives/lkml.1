Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYAAKUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYAAKUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYAAKUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:20:11 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54556 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYAAKUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:20:09 -0500
Date: Tue, 1 Jan 2008 11:20:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       dev-etrax@axis.com
Subject: Re: [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101102010.GD28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072922.GE2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101072922.GE2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:29:22PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all Cris Makefiles.
> 
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/arch/cris/arch-v32/boot/compressed/Makefile b/arch/cris/arch-v32/boot/compressed/Makefile
> index 9f77eda..8586922 100644
> --- a/arch/cris/arch-v32/boot/compressed/Makefile
> +++ b/arch/cris/arch-v32/boot/compressed/Makefile
> @@ -7,7 +7,7 @@
>  target = $(target_compressed_dir)
>  src    = $(src_compressed_dir)
>  
> -CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
> +CC = gcc-cris -mlinux -march=v32 -I $(objtree)/include

As in the mips case the right fix is to use:
> +CC = gcc-cris -mlinux -march=v32 -Iinclude -Iinclude2

In this way we pick up the includes also in the O=..
case.

PS. Mikael - should Jesper be mentioned in MAINTAINERS?

	Sam
