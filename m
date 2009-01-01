Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZAADQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZAADQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 22:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZAADQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 22:16:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47362 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZAADQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 22:16:11 -0500
Subject: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
	match inverted in 2.6.28?)
From: Matthew Helsley <matthltc@us.ibm.com>
Reply-To: matthltc@us.ibm.com
To: Matt Cross <matt.cross@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 19:16:12 -0800
Message-Id: <1230779772.29793.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 17:00 -0500, Matt Cross wrote:
> I think the work to move ebtables to use xtables broke ebtables.
> Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
> return value of the match functions was inverted so that they return 1
> (true) on matches instead of EBT_MATCH (0), and vice versa (look in
> ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
> EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.
> 
> The patch at the end of this message fixes the problem, but seems a
> little hacky to me.  Who's the right person to address this?
> 
>     -Matt

I suspect the right place to send this is:
netfilter-devel@vger.kernel.org

The subject line should indicate that you've contributed a patch
otherwise you may not get a quick response (I've modified it
accordingly).

For more on submitting patches you can read
Documentation/SubmittingPatches and Documentation/SubmitChecklist

Cheers,
	-Matt Helsley

> 
> --- linux-2.6.28.orig/net/bridge/netfilter/ebtables.c   2008-12-24
> 18:26:37.000000000 -0500
> +++ linux-2.6.28/net/bridge/netfilter/ebtables.c        2008-12-31
> 16:17:44.000000000 -0500
> @@ -80,7 +80,7 @@
>  {
>         par->match     = m->u.match;
>         par->matchinfo = m->data;
> -       return m->u.match->match(skb, par);
> +       return !m->u.match->match(skb, par);
>  }
> 
>  static inline int ebt_dev_check(char *entry, const struct net_device *device)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

