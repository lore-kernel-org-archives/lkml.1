Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908Ab0AQLkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0AQLkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 06:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809Ab0AQLkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 06:40:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35239 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0AQLku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 06:40:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B52F734.6000408@s5r6.in-berlin.de>
Date: Sun, 17 Jan 2010 12:40:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/9] drivers/char: Eliminate useless code
References: <Pine.LNX.4.64.1001161656560.28745@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1001161656560.28745@ask.diku.dk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> The variable x is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
[...]
> --- a/drivers/char/mmtimer.c
> +++ b/drivers/char/mmtimer.c
> @@ -546,9 +546,9 @@ static void mmtimer_tasklet(unsigned long data)
>  {
>  	int nodeid = data;
>  	struct mmtimer_node *mn = &timers[nodeid];
> -	struct mmtimer *x = rb_entry(mn->next, struct mmtimer, list);
> +	struct mmtimer *x;
>  	struct k_itimer *t;
>  	unsigned long flags;

The next x = rb_entry(mn->next, struct mmtimer, list); is preceded by a
test whether mn->next is NULL.

Unless that test is redundant too, your patch fixes a potential NULL
pointer dereference, introduced by commit cbacdd95 "SGI Altix mmtimer:
allow larger number of timers per node" in 2.6.26.
-- 
Stefan Richter
-=====-==-=- ---= =---=
http://arcgraph.de/sr/
