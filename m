Return-Path: <linux-kernel-owner+w=401wt.eu-S1763771AbYCEHCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763771AbYCEHCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbYCEHCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:02:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbYCEHCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:02:39 -0500
Date: Wed, 5 Mar 2008 08:02:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christopher Li <sparse@chrisli.org>
Cc: Julia Lawall <julia@diku.dk>, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
Message-ID: <20080305070201.GA32434@elte.hu>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk> <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christopher Li <sparse@chrisli.org> wrote:

> I think Al Viro has sent a patch to linux-sparse with subject "[PATCH 
> 3/3] catch !x & y brainos" does exactly that.

ah - nice :-)

/me checks the linux-sparse archive

Al's patch is:

+                       if (op == '&' && expr->left->type == EXPR_PREOP &&
+                           expr->left->op == '!')
+                               warning(expr->pos, "dubious: !x & y");

i think there might be similar patterns: "x & !y", "!x | y", "x | !y" ?

	Ingo
