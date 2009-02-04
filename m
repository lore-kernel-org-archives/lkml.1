Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbZBDV0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbZBDV0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZBDV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:26:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44896 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZBDV0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:26:41 -0500
Date: Wed, 4 Feb 2009 22:26:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
	possible
Message-ID: <20090204212612.GN22608@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204150835.GA30027@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch gives arches more freedom on overwriting CFLAGS, specifically
> on PowerPC we want to remove -fno-omit-frame-pointer flag.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 7715b2c..d1ba93f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -525,8 +525,6 @@ else
>  KBUILD_CFLAGS	+= -O2
>  endif
>  
> -include $(srctree)/arch/$(SRCARCH)/Makefile
> -
>  ifneq (CONFIG_FRAME_WARN,0)
>  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
> @@ -555,6 +553,8 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
>  KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
>  endif
>  
> +include $(srctree)/arch/$(SRCARCH)/Makefile
> +
>  # arch Makefile may override CC so keep this after arch Makefile is included
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>  CHECKFLAGS     += $(NOSTDINC_FLAGS)
> -- 

this patch is really for Sam to judge - Cc:-ed him.

	Ingo
