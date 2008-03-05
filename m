Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbYCEMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbYCEMVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764825AbYCEMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:20:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762549AbYCEMUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:20:32 -0500
Date: Wed, 5 Mar 2008 13:20:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: Christopher Li <sparse@chrisli.org>, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
Message-ID: <20080305122010.GA999@elte.hu>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk> <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com> <20080305070201.GA32434@elte.hu> <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk>
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


* Julia Lawall <julia@diku.dk> wrote:

> There are some legitimate uses of !x & y which are actually of the 
> form !x & !y, where x and y are function calls.  That is a not 
> particularly elegant way of getting both x and y to be evaluated and 
> then combining the results using "and".  If such code is considered 
> acceptable, then perhaps the sparse patch should be more complicated.

i tend to be of the opinion that the details in C source code should be 
visually obvious and should be heavily simplified down from what is 
'possible' language-wise - with most deviations and complications that 
depart from convention considered an error. I'd consider "!fn1() & 
!fn2()" a borderline coding style violation in any case - and it costs 
nothing to change it to "!fn1() && !fn2()".

	Ingo
