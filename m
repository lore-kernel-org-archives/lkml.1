Return-Path: <linux-kernel-owner+w=401wt.eu-S1765432AbXHPVC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765432AbXHPVC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764703AbXHPVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:02:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757950AbXHPVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:02:44 -0400
Date: Thu, 16 Aug 2007 14:02:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [-mm patch] AFLAGS: fix the -g setting
Message-Id: <20070816140201.3ff0f582.akpm@linux-foundation.org>
In-Reply-To: <20070814212329.GQ18945@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<20070814212329.GQ18945@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 23:23:29 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> It's -gdwarf-2, not -gdwarf2. With this fix it can actually work.

Andreas Schwab has said "The option is officially called -gdwarf-2, and
-gdwarf2 is an alias for backward compatibility.".  So the code should be
working OK now.

> And since even gcc 3.2 supports -gdwarf-2 there's no reason for checking 
> with as-option.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 6ab1091b06e762635430b452f82a474890bda230 
> diff --git a/Makefile b/Makefile
> index 5b0d58c..accfdc4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -504,7 +504,7 @@ endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  CFLAGS		+= -g
> -AFLAGS		+= $(call as-option, -gdwarf2)
> +AFLAGS		+= -gdwarf-2
>  endif
>  
>  # Force gcc to behave correct even for buggy distributions
