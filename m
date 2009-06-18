Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZFRUy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZFRUy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZFRUyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:54:20 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:45432 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644AbZFRUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:54:19 -0400
Subject: Re: [freetel-oslec] [PATCH] fix Pstate growing in OSLEC
From: David Rowe <david@rowetel.com>
To: Open Source Line Echo Canceller 
	<freetel-oslec@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <20090618174540.GT3311@xorcom.com>
References: <20090618174540.GT3311@xorcom.com>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 06:24:06 +0930
Message-Id: <1245358446.6714.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tzafrir,

I submitted the patch to Greg a few weeks ago (as well as checking it
into Oslec SVN).

Re gathering dust, on the contrary I understand that many people are
using Oslec from the kernel staging directory with the Asterisk DAHDI
interface.

Cheers,

David

On Thu, 2009-06-18 at 20:45 +0300, Tzafrir Cohen wrote:
> The following fix has been posted in the OSLEC mailing list by Ruslan
> Cray (and shortly afterwards acepted into the OSLEC SVN tree). Sadly it
> has not been forwarded the kernel.org tree until now.
> 
> See:
> 
> http://sourceforge.net/mailarchive/forum.php?thread_name=000b01c9d88f%24ec689690%2475a8a8c0%40rcraydvlpmnt&forum_name=freetel-oslec
> 
> As a side note, the OSLEC code is gathering dust in the staging tree.
> As-is it is mostly useless without providing an interface for its code.
> I was hoping to see the mISDN code starting to use it but so far no 
> change in that front.
> 
> ---
>  drivers/staging/echo/echo.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
> index 6d7217e..faab26d 100644
> --- a/drivers/staging/echo/echo.c
> +++ b/drivers/staging/echo/echo.c
> @@ -395,7 +395,7 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
>  		old = (int)ec->fir_state.history[ec->fir_state.curr_pos] *
>  		    (int)ec->fir_state.history[ec->fir_state.curr_pos];
>  		ec->Pstates +=
> -		    ((new - old) + (1 << ec->log2taps)) >> ec->log2taps;
> +		    ((new - old) + (1 << (ec->log2taps - 1))) >> ec->log2taps;
>  		if (ec->Pstates < 0)
>  			ec->Pstates = 0;
>  	}
> -- 
> 1.5.6.5
> 
> 
-- 
Free Telephony Project
open embedded IP-PBX hardware and software
http://www.rowetel.com/ucasterisk

