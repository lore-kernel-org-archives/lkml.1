Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZCOOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZCOOzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZCOOzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 10:55:01 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:60885 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZCOOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 10:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s0talBop3WsLC/kR1SlBrr/h0wWZLLDfhLkoQEwvZA/SdaseDFKBY7sgzayCnMcnFQ
         mqV4uebZnMpHLiSgMdzgd9izTlPeB9swFXUmxeuf7B+AXsPRV9p1dYygz5SK5r8qF1fu
         7STBNiqtDob/M5exXm96P/5mH33fVlPZo1plE=
Date: Sun, 15 Mar 2009 15:54:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com, jeremy@goop.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/printk] fix regression from "vsprintf: unify the
	format decoding layer for its 3 users"
Message-ID: <20090315145453.GA5105@nowhere>
References: <tip-adf26f84a62b492e002d3b75af671f23ddd3be0a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-adf26f84a62b492e002d3b75af671f23ddd3be0a@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 11:39:47AM +0000, Vegard Nossum wrote:
> Commit-ID:  adf26f84a62b492e002d3b75af671f23ddd3be0a
> Gitweb:     http://git.kernel.org/tip/adf26f84a62b492e002d3b75af671f23ddd3be0a
> Author:     Vegard Nossum <vegard.nossum@gmail.com>
> AuthorDate: Sat, 14 Mar 2009 12:08:50 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 14 Mar 2009 12:37:08 +0100
> 
> fix regression from "vsprintf: unify the format decoding layer for its 3 users"
> 
> Jeremy Fitzhardinge reported:
> 
> > Change fef20d9c1380f04ba9492d6463148db07b413708, "vsprintf:
> > unify the format decoding layer for its 3 users", causes a
> > regression in xenbus which results in no devices getting
> > attached to a new domain.
> 
> %.*s is broken - fix it.
> 
> Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  lib/vsprintf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index dc16743..708e505 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -843,7 +843,7 @@ precision:
>  				spec->precision = 0;
>  		} else if (*fmt == '*') {
>  			/* it's the next argument */
> -			spec->type = FORMAT_TYPE_WITDH;
> +			spec->type = FORMAT_TYPE_PRECISION;
>  			return ++fmt - start;
>  		}
>  	}

Thanks a lot for this patch!

Frederic.

