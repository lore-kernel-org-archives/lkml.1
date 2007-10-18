Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXJRWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXJRWJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761690AbXJRWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:09:09 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:43278 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbXJRWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:09:07 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] Freezer: Do not allow freezing processes to clear TIF_SIGPENDING
Date: Fri, 19 Oct 2007 08:09:02 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200710190022.36145.rjw@sisk.pl>
In-Reply-To: <200710190022.36145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710190809.03042.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 19 October 2007 08:22:35 Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
> to prevent them from racing with the freezer (like mysqld does, for 
example).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Nigel Cunningham <nigel@suspend2.net>

> ---
>  kernel/signal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-mm1/kernel/signal.c
> ===================================================================
> --- linux-2.6.23-mm1.orig/kernel/signal.c
> +++ linux-2.6.23-mm1/kernel/signal.c
> @@ -124,7 +124,7 @@ void recalc_sigpending_and_wake(struct t
>  
>  void recalc_sigpending(void)
>  {
> -	if (!recalc_sigpending_tsk(current))
> +	if (!recalc_sigpending_tsk(current) && !freezing(current))
>  		clear_thread_flag(TIF_SIGPENDING);
>  
>  }
> 



-- 
Nigel, Michelle, Alisdair and ____________ Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia
