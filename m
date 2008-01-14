Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYANI0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYANI0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYANIZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:25:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYANIZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:25:55 -0500
Date: Mon, 14 Jan 2008 09:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Remove timer frequency choice if tickless is enabled
Message-ID: <20080114082543.GC18296@elte.hu>
References: <20080112020026.GB5849@Pilar.physics.ucla.edu> <20080112032718.GA3946@Pilar.socal.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112032718.GA3946@Pilar.socal.rr.com>
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


(lkml Cc:-ed)

* Carlos R. Mafra <crmafra2@gmail.com> wrote:

>  choice
>  	prompt "Timer frequency"
> +	depends on !NO_HZ
>  	default HZ_250
>  	help
>  	 Allows the configuration of the timer frequency. It is customary

we are not there yet to be able to do this. With NO_HZ the tick is only 
disabled when we go idle - but it still runs (and we rely on it, for 
example in the scheduler code) while we are non-idle. Peter Zijlstra is 
working on the 'high-res scheduler tick' feature to remove the scheduler 
dependencies.

	Ingo
