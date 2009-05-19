Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZESKS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZESKS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZESKSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:18:51 -0400
Received: from cmpxchg.org ([85.214.51.133]:37191 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZESKSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:18:51 -0400
Date: Tue, 19 May 2009 12:18:33 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] vmscan: merge duplicate code in shrink_active_list()
Message-ID: <20090519101833.GA1872@cmpxchg.org>
References: <20090517022327.280096109@intel.com> <20090517022742.320921900@intel.com> <20090518091653.GB10439@localhost> <20090519024316.GA7562@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519024316.GA7562@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 10:43:16AM +0800, Wu Fengguang wrote:
> @@ -1283,6 +1319,7 @@ static void shrink_active_list(unsigned 
>  			 * are ignored, since JVM can create lots of anon
>  			 * VM_EXEC pages.
>  			 */
> +			if (page_cluster)
>  			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
>  				list_add(&page->lru, &l_active);
>  				continue;

Huh, what's with that hunk?
