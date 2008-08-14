Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYHNNu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYHNNu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:50:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHNNuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:50:14 -0400
Date: Thu, 14 Aug 2008 15:49:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH](retry 3) invalidate caches before going into suspend
Message-ID: <20080814134951.GA14333@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <6453C3CB8E2B3646B0D020C112613273C5AC6B@sausexmb4.amd.com> <20080813143206.07550498@infradead.org> <200808140845.05160.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808140845.05160.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> + * Systems without cache can just go into halt.
> + */
> +static void wbinvd_halt(void) {

please put this into a unified include file, and as an inline - there's 
just a single callsite. That avoids duplication and also removes a 
function.

Also, please run the patch through scripts/checkpatch, it would have 
suggested to change this:

> +static void wbinvd_halt(void) {

to:

> +static void wbinvd_halt(void)
> +{

Thanks,

	Ingo
