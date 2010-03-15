Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936094Ab0COKAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:00:32 -0400
Received: from trinity.develer.com ([83.149.158.210]:53694 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936084Ab0COKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:00:28 -0400
Date: Mon, 15 Mar 2010 11:00:25 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
Message-ID: <20100315100024.GA1653@linux.develer.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
 <1268609202-15581-2-git-send-email-arighi@develer.com>
 <20100315090638.ee416d93.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315090638.ee416d93.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 09:06:38AM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 15 Mar 2010 00:26:38 +0100
> Andrea Righi <arighi@develer.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, file-mapped is maintaiend. But more generic update function
> > will be needed for dirty page accounting.
> > 
> > For accountig page status, we have to guarantee lock_page_cgroup()
> > will be never called under tree_lock held.
> > To guarantee that, we use trylock at updating status.
> > By this, we do fuzzy accounting, but in almost all case, it's correct.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Bad patch title...."use trylock for safe accounting in some contexts" ?

OK, sounds better. I just copy & paste the email subject, but the title
was probably related to the old lock_page_cgroup()+irq_disable patch.

Thanks,
-Andrea
