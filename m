Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZIKWyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZIKWyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZIKWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:54:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12106 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZIKWyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:54:09 -0400
Date: Sat, 12 Sep 2009 00:54:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make sure the value in abs() does not get truncated if
 it is greater than 2^32
In-Reply-To: <200909032312.10418.eike-kernel@sf-tec.de>
Message-ID: <alpine.LNX.2.00.0909120053470.31018@swampdragon.chaosbits.net>
References: <200909032312.10418.eike-kernel@sf-tec.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Rolf Eike Beer wrote:

> I was just digging a bit around in linux/kernel.h and stumbled over the abs() 
> makro. For me it looks as it would return wrong results on 64 bit platforms 
> if the input value is greater than 2^32.
> 

I think you are right.


> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  include/linux/kernel.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6320a3..1e6eb66 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -145,7 +145,7 @@ extern int _cond_resched(void);
>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>  
>  #define abs(x) ({				\
> -		int __x = (x);			\
> +		long __x = (x);			\
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

