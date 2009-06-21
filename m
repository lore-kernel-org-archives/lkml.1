Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZFULft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZFULft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZFULfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:35:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZFULfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:35:41 -0400
Date: Sun, 21 Jun 2009 13:35:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: mm/init_32.c fix style problems
Message-ID: <20090621113505.GA25243@elte.hu>
References: <1245583492.3052.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245583492.3052.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> Impact: cleanup
> 
> Fix :
> 
> WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> ERROR: do not initialise externals to 0 or NULL
> ERROR: code indent should use tabs where possible
> ERROR: space required after that ',' (ctx:VxV)
> ERROR: spaces required around that ':' (ctx:ExV) X 3
> 
> total: 6 errors, 1 warning
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/mm/init_32.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)

Just like with hugetlbpage.c, this file too has other problems 
beyond trivial style issues:

 - one_page_table_init() logic should be restructured to have its 
   branch condition inverted into a goto out pattern, to get rid of 
   the ugly linebreaks.

 - that ugly check in page_table_kmap_check() should be factored out
   into a helper inline

 - kernel_physical_mapping_init() is too large and should have its 
   innards factored out into one or more helper inlines.

 - there's too many #idefs obscuring the easy readability of the 
   code. Could some be eliminated?

Some style issues as well:

 - printk(KERN_* should be converted to pr_*(

 - the #include files section looks unstructured and ugly. Please 
   take a look at arch/x86/mm/fault.c and try to eliminate all 
   unnecessary include lines and follow the format of fault.c.

These (and other issues) should be addressed as well, so that we 
have a single act of churn there, followed by a quality end result.

Thanks,

	Ingo
