Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZD3AKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZD3AKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZD3AKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:10:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727AbZD3AKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:10:19 -0400
Date: Wed, 29 Apr 2009 17:06:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090429232546.GB15782@Krystal>
Message-ID: <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain>
References: <20090429232546.GB15782@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
>
> This patch adds missing dirty page accounting in redirty_page_for_writepage().
> This should fix a _lot_ of issues involving machines becoming slow under heavy
> write I/O. No surprise : eventually the system starts swapping.

That patch (and description) is odd.

The patch actually adds the dirty page accounting not to 
redirty_page_for_writepage(), but to __set_page_dirty_nobuffers().

And __set_page_dirty_nobuffers() will later (just a few lines down) call 
down to account_page_dirtied(), which in turn does all that 
same accounting (assuming the "mapping" is marked to account for dirty.

So the description seems to be wrong, but so does the patch. 

Did you attach the wrong patch (explaining both problems)?

Or if the patch is what you really meant to do, then you need to fix your 
explanation, and also explain why the double-dirty accounting is a good 
idea.

Or is the real problem perhaps that your /tmp is ramdisk, and not marked 
to do dirty accounting?

		Linus
