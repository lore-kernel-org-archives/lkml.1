Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZIWKmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZIWKmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZIWKmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:42:10 -0400
Received: from cmpxchg.org ([85.214.51.133]:52618 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIWKmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:42:09 -0400
Date: Wed, 23 Sep 2009 12:41:51 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
Message-ID: <20090923104151.GA22262@cmpxchg.org>
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 23, 2009 at 05:38:01AM -0400, Amerigo Wang wrote:
> 
> I got lots of "ISO C90 forbids mixed declarations and code" warnings
> during compile today's kernel.

Yeah, see http://lkml.org/lkml/2009/9/22/585 .

> I think we can remove the gcc option '-Wdeclaration-after-statement'
> now, since we already have C99 for 10 years. :)

It's still ugly and uncommon to have variable declarations appear
randomly in block bodies, please keep the warning.

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
> diff --git a/Makefile b/Makefile
> index 433493a..038bda2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -559,9 +559,6 @@ endif
>  NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
>  CHECKFLAGS     += $(NOSTDINC_FLAGS)
>  
> -# warn about C99 declaration after statement
> -KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
> -
>  # disable pointer signed / unsigned warnings in gcc 4.0
>  KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)

	Hannes
