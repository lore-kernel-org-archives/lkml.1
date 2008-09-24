Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYIXHyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYIXHyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYIXHxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:53:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYIXHxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:53:53 -0400
Date: Wed, 24 Sep 2008 09:53:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix endian bug in openfirmware workaround
Message-ID: <20080924075338.GE3655@elte.hu>
References: <1222208409.16003.25.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222208409.16003.25.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Boardrev is always treated as a u32 everywhere else, no reason to 
> byteswap the 0xc2 value.  The only use is to print out if it is a 
> prerelease board, the test being:
> 
> (olpc_platform_info.boardrev & 0xf) < 8
> 
> Which is currently always true as be32_to_cpu(0xc2) & 0xf = 0
> but I doubt that was the intention here.  The consequences of the bug
> are pretty minor though (incorrect boardrev displayed in dmesg when
> ofw support not configured)
> 
> Also annotate the temporary used to read the boardrev in the ofw
> case.
> 
> The confusion was noticed by sparse:
> arch/x86/kernel/olpc.c:206:32: warning: cast to restricted __be32
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

applied to tip/x86/sparse-fixes, thanks Harvey!

	Ingo
