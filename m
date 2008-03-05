Return-Path: <linux-kernel-owner+w=401wt.eu-S1763392AbYCEI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392AbYCEI4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbYCEI4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:56:00 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37555 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYCEIz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:55:59 -0500
Date: Wed, 5 Mar 2008 09:55:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christopher Li <sparse@chrisli.org>, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
 use of ! and &
In-Reply-To: <20080305070201.GA32434@elte.hu>
Message-ID: <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
 <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
 <20080305070201.GA32434@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some legitimate uses of !x & y which are actually of the form !x 
& !y, where x and y are function calls.  That is a not particularly 
elegant way of getting both x and y to be evaluated and then combining the 
results using "and".  If such code is considered acceptable, then perhaps 
the sparse patch should be more complicated.

julia

> Al's patch is:
> 
> +                       if (op == '&' && expr->left->type == EXPR_PREOP &&
> +                           expr->left->op == '!')
> +                               warning(expr->pos, "dubious: !x & y");
> 
> i think there might be similar patterns: "x & !y", "!x | y", "x | !y" ?
> 
> 	Ingo
> 
