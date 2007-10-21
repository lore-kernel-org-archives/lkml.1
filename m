Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbXJUH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbXJUH3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXJUH3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:29:25 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:32880 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXJUH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:29:24 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Use a private inode for backing storage
Date: Sun, 21 Oct 2007 09:28:58 +0200
User-Agent: KMail/1.9.7
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710211524.52595.nickpiggin@yahoo.com.au> <m1d4v9c690.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d4v9c690.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710210928.58265.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 21. Oktober 2007 schrieb Eric W. Biederman:
> Nick.  Reread the patch.  The only thing your arguments have
> established for me is that this patch is not obviously correct.  Which
> makes it ineligible for a back port.  Frankly I suspect the whole
> issue is to subtle and rare to make any backport make any sense.  My
> apologies Christian.

About being rare, when I force the VM to be more aggressive reclaiming buffer
by using the following patch:
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -3225,7 +3225,7 @@ void __init buffer_init(void)
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
 	 */
 	nrpages = (nr_free_buffer_pages() * 10) / 100;
-	max_buffer_heads = nrpages * (PAGE_SIZE / sizeof(struct buffer_head));
+	max_buffer_heads = 0;
 	hotcpu_notifier(buffer_cpu_notify, 0);
 }
 
I can actually cause data corruption within some seconds. So I think the
problem is real enough to be worth fixing.

I still dont fully understand what issues you have with my patch.
- it obviously fixes the problem
- I am not aware of any regression it introduces
- its small

One concern you had, was the fact that buffer heads are out of sync with 
struct pages. Testing your first patch revealed that this is actually needed
by reiserfs - and maybe others.
I can also see, that my patch looks a bit like a bandaid that cobbles the rd
pieces together.
Is there anything else, that makes my patch unmergeable in your opinion?


Christian






