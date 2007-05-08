Return-Path: <linux-kernel-owner+w=401wt.eu-S1032043AbXEHUIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032043AbXEHUIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032042AbXEHUIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:08:32 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50725 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032041AbXEHUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:08:29 -0400
Date: Tue, 8 May 2007 21:08:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
In-Reply-To: <20070508114003.GB19294@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705082054500.18925@blonde.wat.veritas.com>
References: <20070508113709.GA19294@wotan.suse.de> <20070508114003.GB19294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 08 May 2007 20:08:26.0425 (UTC) FILETIME=[A358B290:01C791AC]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AG5waWdnaW5Ac3VzZS5kZQBsaW51eC1hcmNoQHZnZXIua2VybmVsLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAYmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Nick Piggin wrote:

> This patch trades a page flag for a significant improvement in the unlock_page
> fastpath. Various problems in the previous version were spotted by Hugh and
> Ben (and fixed in this one).
> 
> Comments?

Seems there's still a bug there.  I get hangs on the page lock, on
i386 and on x86_64 and on powerpc: sometimes they unhang themselves
after a while (presume other activity does the wakeup).  Obvious even
while booting (Starting udevd).  Sorry, not had time to investigate.

Hugh
