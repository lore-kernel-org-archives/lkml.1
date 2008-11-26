Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYKZCuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYKZCuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYKZCuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:50:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYKZCuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:50:06 -0500
Date: Wed, 26 Nov 2008 03:49:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: adding other non-leaving .text sections
Message-ID: <20081126024930.GC31342@elte.hu>
References: <1227666566-9044-1-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227666566-9044-1-git-send-email-liming.wang@windriver.com>
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


* Liming Wang <liming.wang@windriver.com> wrote:

> Please review this patch, and I don't know whether new sections will conflict 
> with sched tracer or others. 
> This patch is against Steven tree's tip/devel latest commit.
> 
> Impact: improve recordmcount.pl
> 
> Besides .text section, there are three .text sections that won't
> be freed after kernel booting. They are: .sched.text, .spinlock.text
> and .kprobes.text, which contain functions we can trace. But the last
> section ".kprobes.text" is particular, which has been marked as "notrace",
> we ignore it. Thus we add other two sections.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  scripts/recordmcount.pl |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 0197e2f..0b1dc9f 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -112,6 +112,8 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
>  # Acceptable sections to record.
>  my %text_sections = (
>       ".text" => 1,
> +     ".sched.text" => 1,
> +     ".spinlock.text" => 1,
>  );

make sense - applied to tip/tracing/ftrace, thanks!

	Ingo
