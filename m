Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXGWIXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXGWIXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGWIXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:23:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38075 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752617AbXGWIXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:23:37 -0400
Message-ID: <385179010.25899@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 23 Jul 2007 16:12:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
Message-ID: <20070723081209.GA12393@mail.ustc.edu.cn>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070721044300.909424569@mail.ustc.edu.cn> <384993020.08966@ustc.edu.cn> <46A45F8A.5060600@yahoo.com.au> <20070723080405.GA7420@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723080405.GA7420@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:04:05PM +0800, Fengguang Wu wrote:
> On Mon, Jul 23, 2007 at 05:58:02PM +1000, Nick Piggin wrote:
> > Fengguang Wu wrote:
> > >Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
> > >for the first hole. It will be used in interleaved readahead.
> > >
> > >The implementation is dumb and obviously correct.
> > >It can help debug(and document) the possible smart one in future.
> > 
> > Reasonable function to want. Is radix_tree_scan_hole the best name?
> > What about radix_tree_next_hole or _find_next_hole? (Andrew, any
> > suggestions?)
> 
> Thank you!
> 
> All comments seems reasonable, so I simply attach the updated patch.
> 
> Fengguang
> ---
> Subject: radixtree: introduce radix_tree_next_hole()
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> 
> Introduce radix_tree_next_hole(root, index, max_scan) to scan radix tree
> for the first hole. It will be used in interleaved readahead.
> 
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

And another rename fix for the interleaved readahead patch.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
@@ -372,7 +372,7 @@ ondemand_readahead(struct address_space 
 		pgoff_t start;
 
 		read_lock_irq(&mapping->tree_lock);
-		start = radix_tree_scan_hole(&mapping->page_tree, offset, max+1);
+		start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);
 		read_unlock_irq(&mapping->tree_lock);
 
 		if (!start || start - offset > max)

