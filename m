Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYH1Xh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYH1Xh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYH1XhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:37:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35462 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYH1XhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:37:12 -0400
Date: Fri, 29 Aug 2008 08:35:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: kosaki.motohiro@jp.fujitsu.com,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, Adam Litke <agl@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0808281724300.11072@blonde.site>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0808281724300.11072@blonde.site>
Message-Id: <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I think VM_RESERVED default dumping bahavior is good,
> > then I'd like to add coredump_filter mask.
> > 
> > This patch doesn't change dafault behavior.
> 
> This seems very reasonable to me
> (though I've little use for coredumps or hugepages myself).

Thanks a lot.

> One caution though: how well does it behave when coredumping a large
> area of hugepages which have not actually been instantiated prior to
> the coredump?  We have that funny FOLL_ANON ZERO_PAGE code in
> follow_page() to avoid wasting memory on large uninstantiated anon
> areas, but hugepages won't go that way.  If the dump hangs waiting for
> memory to be freed, or OOMkills other processes, that wouldn't be good;
> whereas if hugepage reservations (I've not followed what happens with
> them) or whatever just make it skip when no more, that should be okay.

I think hugepage reservation pages always exist when hugepage COW happend.
Then, hugepage access never cause try_to_free_pages() nor OOM.

Adam, if I talk lie, please tell us truth.




