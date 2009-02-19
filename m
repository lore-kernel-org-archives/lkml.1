Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZBSTuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZBSTuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZBSTuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:50:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56367 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZBSTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:50:03 -0500
Message-ID: <499DB6EC.3020904@cs.helsinki.fi>
Date: Thu, 19 Feb 2009 21:45:48 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Matt Mackall <mpm@selenic.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Vrabel <david.vrabel@csr.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/7] slab: introduce kzfree()
References: <499BE7F8.80901@csr.com>  <1234954488.24030.46.camel@penberg-laptop>  <20090219101336.9556.A69D9226@jp.fujitsu.com>  <1235034817.29813.6.camel@penberg-laptop>  <Pine.LNX.4.64.0902191616250.8594@blonde.anvils> <1235066556.3166.26.camel@calx> <Pine.LNX.4.64.0902191819060.28475@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902191819060.28475@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh.

Hugh Dickins wrote:
> Thanks for that, I remember it now.
> 
> Okay, that's some justification for kfree(const void *).
> 
> But I fail to see it as a justification for kzfree(const void *):
> if someone has "const char *string = kmalloc(size)" and then
> wants that string zeroed before it is freed, then I think it's
> quite right to cast out the const when calling kzfree().

Quite frankly, I fail to see how kzfree() is fundamentally different 
from kfree(). I don't see kzfree() as a memset() + kfree() but rather as 
a kfree() "and make sure no one sees my data". So the zeroing happens 
_after_ you've invalidated the pointer with kzfree() so there's no 
"zeroing of buffer going on". So the way I see it, Linus' argument for 
having const for kfree() applies to kzfree().

That said, if you guys think it's a merge blocker, by all means remove 
the const. I just want few less open-coded ksize() users, that's all.

			Pekka
