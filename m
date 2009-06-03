Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZFCLRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZFCLRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZFCLRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:17:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZFCLRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:17:47 -0400
Date: Wed, 3 Jun 2009 13:24:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090603112456.GA1065@one.firstfloor.org>
References: <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602134659.GA21338@localhost> <20090602151729.GC17448@wotan.suse.de> <20090602172715.GT1065@one.firstfloor.org> <20090603093546.GA16275@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603093546.GA16275@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 11:35:46AM +0200, Nick Piggin wrote:
> On Tue, Jun 02, 2009 at 07:27:15PM +0200, Andi Kleen wrote:
> > > Hmm, if you're handling buffercache here then possibly yes.
> > 
> > Good question, will check.
> 
> BTW. now that I think about it, buffercache is probably not a good
> idea to truncate (truncate, as-in: remove from pagecache). Because
> filesystems can assume that with just a reference on the page, then
> it will not be truncated.

Yes I understand. Need to check for this, but I'm not sure
how we can reliably detect it based on the struct page alone. I guess we have 
to look at the mapping.

> So I think it would be a good idea to exclude buffercache from
> here completely until it can be shown to be safe. Actually you

Agreed. Just need to figure out how.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
