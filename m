Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZF0WY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZF0WY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 18:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZF0WYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 18:24:20 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59257 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZF0WYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 18:24:19 -0400
Date: Sat, 27 Jun 2009 23:53:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers_check fix: linux/pps.h
Message-ID: <20090627215346.GA2719@uranus.ravnborg.org>
References: <1246120414.32198.5.camel@hpdv5.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246120414.32198.5.camel@hpdv5.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 10:03:34PM +0530, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/pps.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pps.h b/include/linux/pps.h
> index cfe5c72..0194ab0 100644
> --- a/include/linux/pps.h
> +++ b/include/linux/pps.h
> @@ -22,6 +22,8 @@
>  #ifndef _PPS_H_
>  #define _PPS_H_
>  
> +#include <linux/types.h>
> +
>  #define PPS_VERSION		"5.3.6"
>  #define PPS_MAX_SOURCES		16		/* should be enough... */

That file has other issues that should be addresses too.
1) It uses int rather than wide specific types
2) It uses structs with questionable alignmner as per David's comment

Keeping the warning until all issues are sorted out is preferred.
If we 'fix' the warning then we loose the reminder that this file
needs to be eyeballed.

This is not a quest to eliminate warnings - this is a quest to
raise the quality and correctness of the exported headers.
The warnings serves as reminders where to focus attention.

	Sam
