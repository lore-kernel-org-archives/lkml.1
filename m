Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYLBA5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYLBA5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYLBA5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:57:09 -0500
Received: from ozlabs.org ([203.10.76.45]:40355 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYLBA5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:57:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request at ffff8800be8b0019
Date: Tue, 2 Dec 2008 11:27:02 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Hugh Dickins <hugh@veritas.com>, penberg@cs.helsinki.fi, rjw@sisk.pl,
       miles.lane@gmail.com, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, htejun@gmail.com,
       vegard.nossum@gmail.com, rostedt@goodmis.org, arjan@infradead.org
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com> <Pine.LNX.4.64.0811271643250.9618@blonde.site> <20081201125103.db4c026f.akpm@linux-foundation.org>
In-Reply-To: <20081201125103.db4c026f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021127.03631.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008 07:21:03 Andrew Morton wrote:
> The fault really lies with include/linux/kallsyms.h, I think:
>
> #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1)
> + \ 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)

Hmm... and I recently define MODULE_NAME_LEN in terms of MAX_PARAM_PREFIX_LEN 
for similar reasons.

Perhaps we should move MODULE_NAME_LEN to kernel.h and define everything in 
terms of that?  It seems to be a common need.

Rusty.
