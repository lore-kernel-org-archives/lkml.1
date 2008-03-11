Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYCKJjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYCKJjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYCKJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:39:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYCKJjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:39:23 -0400
Date: Tue, 11 Mar 2008 10:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephan Diestelhorst <langer_mann@web.de>
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Message-ID: <20080311093903.GS25110@elte.hu>
References: <200803051559.09962.langer_mann@web.de> <200803101605.42251.langer_mann@web.de> <87iqzu8r2q.fsf@basil.nowhere.org> <200803102226.39044.langer_mann@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803102226.39044.langer_mann@web.de>
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


* Stephan Diestelhorst <langer_mann@web.de> wrote:

> Please also note that these are not clobbers in the strict inline asm 
> syntax, but rather dummy output values that correspond to actual input 
> parameters. I'd consider this a serious compiler flaw, if not bug, if 
> these would not work. But let's not get into GCC vs. 
> Fancy-inline-asm-hacker flames, like the mplayer folks do ;-)

yep, that's my experience as well - output constraints are pretty robust 
in general, but if one tries the same effect via the clobber list it's 
easy to run into gcc internal errors. I've applied your patch to 
x86.git. Do you think it's 2.6.25 material? I'm inclined to have it in 
the 2.6.26 bucket. We could do your first, minimal fix in 2.6.25 and do 
this second, full fix in 2.6.26.

	Ingo
