Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0CBPuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:50:10 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:34185 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0CBPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:50:08 -0500
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1267537736.25158.54.camel@laptop>
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
	 <1267478620-5276-4-git-send-email-arighi@develer.com>
	 <1267537736.25158.54.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 10:49:05 -0500
Message-ID: <1267544945.3099.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 1 sum rcpts/h 12 sum msgs/h 1 total rcpts 2487 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BC30A512349637578AE02FB96807E60CB4A15003
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 207 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 14:48 +0100, Peter Zijlstra wrote: 
> unsigned long reclaimable_pages(cgroup)
> {
>   if (mem_cgroup_has_dirty_limit(cgroup))
>     return mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
>   
>   return global_page_state(NR_FILE_DIRTY) + global_page_state(NR_NFS_UNSTABLE);
> }
> 
> Which raises another question, you should probably rebase on top of
> Trond's patches, which removes BDI_RECLAIMABLE, suggesting you also
> loose MEMCG_NR_RECLAIM_PAGES in favour of the DIRTY+UNSTABLE split.
> 

I'm dropping those patches for now. The main writeback change wasn't too
favourably received by the linux-mm community so I've implemented an
alternative that only changes the NFS layer, and doesn't depend on the
DIRTY+UNSTABLE split.

Cheers
  Trond

