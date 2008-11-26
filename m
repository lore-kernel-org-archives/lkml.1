Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYKZDDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYKZDDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYKZDDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:03:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYKZDDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:03:37 -0500
Date: Tue, 25 Nov 2008 22:03:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Liming Wang <liming.wang@windriver.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: adding other non-leaving .text sections
In-Reply-To: <1227666566-9044-1-git-send-email-liming.wang@windriver.com>
Message-ID: <alpine.DEB.1.10.0811252201270.26424@gandalf.stny.rr.com>
References: <1227666566-9044-1-git-send-email-liming.wang@windriver.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Liming Wang wrote:

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

Yep, only those sections that we know will not disappear are OK. I was
conservative with only using ".text" but I knew there were other sections 
that were OK, so I used the hash array to make it easy to add others.

Thanks!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

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
>  
>  $objdump = "objdump" if ((length $objdump) == 0);
> -- 
> 1.6.0.3
> 
> 
> 
