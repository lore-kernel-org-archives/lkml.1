Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbXKBBdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbXKBBdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXKBBd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:33:27 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51879 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753350AbXKBBdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:33:25 -0400
Message-ID: <393967208.19783@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 2 Nov 2007 09:33:21 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost> <20071101141414.GZ25561@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101141414.GZ25561@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1InlPV-0001f1-SL@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 09:14:14AM -0500, Florin Iucha wrote:
> On Thu, Nov 01, 2007 at 09:03:33PM +0800, Fengguang Wu wrote:
> > Or will the system or fs size/age make any difference? If you happen
> > to have a spare/swap partition, could you make a new reiserfs and
> > mount it and copy several less-than-4KB files into it and wait for 30s
> > and see what happen to pdflush?
> 
> I will try that with a USB disk - I hope that won't make a difference.

Thank you. I guess a reiserfs on loop file would also be OK.

> > btw, what's the exact kernel version you are running?
> 
> I noticed it with the kernel in the $SUBJECT, as reported by 'git
> describe'.  I have pulled in new changesets since then.

And with the following patch applied?

---
 fs/reiserfs/stree.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
+++ linux-2.6.24-git17/fs/reiserfs/stree.c
@@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
 				}
 				bh = next;
 			} while (bh != head);
-			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
-			}
 		}
 	}
 }

