Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYEETz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYEETz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYEETzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:55:14 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38936 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYEETzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:55:12 -0400
Date: Mon, 5 May 2008 21:55:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths only
Message-ID: <20080505195548.GC8868@uranus.ravnborg.org>
References: <481F26A0.5010402@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481F26A0.5010402@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 05:24:16PM +0200, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  scripts/Kbuild.include |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc1/scripts/Kbuild.include
> ===================================================================
> --- linux-2.6.26-rc1.orig/scripts/Kbuild.include
> +++ linux-2.6.26-rc1/scripts/Kbuild.include
> @@ -144,7 +144,7 @@ ld-option = $(call try-run,\
>  build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
>  
>  # Prefix -I with $(srctree) if it is not an absolute path.
> -addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
> +addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
>  
>  # Find all -I options and call addtree
>  flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))

We try to make all paths relative so less files get rebuild if you access the
same source from two different paths (think nfs mounted src etc).
So you really need to justify this change.

	Sam
