Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbXCTTuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbXCTTuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXCTTuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:50:54 -0400
Received: from djz248.neoplus.adsl.tpnet.pl ([83.24.3.248]:64700 "EHLO
	djz248.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbXCTTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:50:54 -0400
Message-ID: <46003B1B.9070601@o2.pl>
Date: Tue, 20 Mar 2007 20:50:51 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070320)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca> <200703192353.19673.a1426z@gawab.com>
In-Reply-To: <200703192353.19673.a1426z@gawab.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> --- sched.bak.c	2007-03-16 23:07:23.000000000 +0300
> +++ sched.c	2007-03-19 23:49:40.000000000 +0300
> @@ -938,7 +938,11 @@ static void activate_task(struct task_st
>  				     (now - p->timestamp) >> 20);
>  	}
>  
> -	p->quota = rr_quota(p);
> +	/*
> +	 * boost factor hardcoded to 5; adjust to your liking
> +	 * higher means more likely to DoS
> +	 */
> +	p->quota = rr_quota(p) + (((now - p->timestamp) >> 20) * 5);
>  	p->prio = effective_prio(p);
>  	p->timestamp = now;
>  	__activate_task(p, rq);

i've tried this and it lasted only a few minutes -- i was seeing
mouse cursor stalls lasting almost 1s. i/o bound tasks starving X?
After reverting the patch everything is smooth again.

artur

