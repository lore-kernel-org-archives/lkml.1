Return-Path: <linux-kernel-owner+w=401wt.eu-S934980AbZLGKI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbZLGKI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934942AbZLGKIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:08:25 -0500
Received: from mx.sz.bfs.de ([194.94.69.70]:40304 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934938AbZLGKIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:08:24 -0500
Message-ID: <4B1CD40F.4010407@bfs.de>
Date: Mon, 07 Dec 2009 11:08:15 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] tools/perf/util: correct size computation
References: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> The size argument to zalloc should be the size of desired structure,
> not the pointer to it.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @expression@
> expression *x;
> @@
> 
> x =
>  <+...
> -sizeof(x)
> +sizeof(*x)
> ...+>// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  tools/perf/util/parse-events.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to
>  			if (id == config) {
>  				closedir(evt_dir);
>  				closedir(sys_dir);
> -				path = zalloc(sizeof(path));
> +				path = zalloc(sizeof(*path));
>  				path->system = malloc(MAX_EVENT_LENGTH);
>  				if (!path->system) {
>  					free(path);

and zalloc() can not fail ?
re,
 wh
