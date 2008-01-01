Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYAAKad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYAAKad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYAAKa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:30:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58226 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYAAKaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:30:25 -0500
Date: Tue, 1 Jan 2008 11:30:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tim Shimmin <xfs-masters@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 7/8] FS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101103026.GG28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101074105.GH2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101074105.GH2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:41:05PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all fs/ Makefiles.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Tim Shimmin <xfs-masters@oss.sgi.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/fs/smbfs/Makefile b/fs/smbfs/Makefile
> index 6673ee8..9b5e92b 100644
> --- a/fs/smbfs/Makefile
> +++ b/fs/smbfs/Makefile
> @@ -34,5 +34,5 @@ proto:
>  	@echo >> proto2.h "struct sock;"
>  	@echo >> proto2.h "struct statfs;"
>  	@echo >> proto2.h ""
> -	cproto -E "gcc -E" -e -v -I $(TOPDIR)/include -DMAKING_PROTO -D__KERNEL__ $(SRC) >> proto2.h
> +	cproto -E "gcc -E" -e -v -I $(objtree)/include -DMAKING_PROTO -D__KERNEL__ $(SRC) >> proto2.h
>  	mv proto2.h proto.h
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 49e3e7e..d1d3d49 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -1 +1 @@
> -include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
> +include $(objtree)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)

The whole "Maintainer rules" part of this file should be deleted.
I cannot see how it can be used anyway.

	Sam
