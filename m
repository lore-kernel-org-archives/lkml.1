Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbYJTGw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbYJTGw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYJTGwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:52:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYJTGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:52:19 -0400
Date: Mon, 20 Oct 2008 08:52:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Breaks the redundant loop in kernel/marker.c
Message-ID: <20081020065205.GA12927@elte.hu>
References: <48FC273B.3030300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC273B.3030300@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/marker.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 7d1faec..2c3172d 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -836,8 +836,6 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
>  			if (!e->ptype) {
>  				if (num == 0 && e->single.func == probe)
>  					return e->single.probe_private;
> -				else
> -					break;
>  			} else {
>  				struct marker_probe_closure *closure;
>  				int match = 0;
> @@ -849,6 +847,7 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
>  						return closure[i].probe_private;
>  				}
>  			}
> +			break;
>  		}
>  	}
>  	return ERR_PTR(-ENOENT);

hm, could you describe the necessity of this patch some more? This has 
the change to change behavior, which might even be a bugfix: is there 
any chance that the closure-loop in the e->ptype != NULL branch does not 
exit? Before your patch we'd continue the iteration - which _probably_ 
does not lead to any more matches (e->name is supposed to be unique).

	Ingo
