Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbYCEMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbYCEMh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbYCEMhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:37:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbYCEMhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:37:04 -0500
Date: Wed, 5 Mar 2008 13:36:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, Christopher Li <sparse@chrisli.org>,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
Message-ID: <20080305123641.GA2365@elte.hu>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk> <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com> <20080305070201.GA32434@elte.hu> <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk> <20080305122010.GA999@elte.hu> <e2e108260803050430o317d3e0dyed50e86cc4569746@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260803050430o317d3e0dyed50e86cc4569746@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bart Van Assche <bart.vanassche@gmail.com> wrote:

> If someone writes (!x & !y) instead of (!x && !y) because both x and y 
> have to be evaluated, this means that both x and y have side effects.
> Please keep in mind that the C language does not specify whether x or 
> y has to be evaluated first, so if x and y have to be evaluated in 
> that order, an expression like (!x & !y) can be the cause of very 
> subtle bugs. I prefer readability above brevity.

such expressions _must_ be written as:

  ret1 = x();
  ret2 = y();

  if (ret1 && ret2)
	...

any side-effects are totally un-obvious when they are in expressions and 
someone doing cleanups later on could easily change the '&' to '&&' and 
introduce a bug.

	Ingo
