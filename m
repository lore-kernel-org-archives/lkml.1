Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbYLYD22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbYLYD22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 22:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYLYD2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 22:28:19 -0500
Received: from ozlabs.org ([203.10.76.45]:38428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYLYD2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 22:28:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: linux-next: parsing mem=700M broken
Date: Thu, 25 Dec 2008 13:58:12 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <200812241808.16195.rusty@rustcorp.com.au> <Pine.LNX.4.64.0812241437230.15556@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0812241437230.15556@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812251358.13635.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 December 2008 01:14:35 Hugh Dickins wrote:
> On Wed, 24 Dec 2008, Rusty Russell wrote:
> > mem= is actually easy, memmap= is harder.  This is tested and pushed.
> 
> Thanks, that gets my "mem=700M" respected on x86_32 and x86_64.
> But (of course: it's a patch to arch/x86) doesn't help at all on
> ppc64; and I presume other architectures also remain broken...

No, the problem is that early_param() get parsed *earlier* with these
changes.  x86 relied on the e820 map already being set up.  Most archs
(like powerpc) just set a "memory_limit" and handle it later; this
is in fact how the vast majority of early_param() work.

This cleanup is getting hairier, however we should see it as a chance
to clean some of this code too I guess...

Thanks,
Rusty.
