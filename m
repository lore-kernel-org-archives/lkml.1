Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbXEXT2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbXEXT2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXEXT2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:28:40 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbXEXT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:28:40 -0400
Date: Thu, 24 May 2007 12:28:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Message-Id: <20070524122810.3c02b257.akpm@linux-foundation.org>
In-Reply-To: <20070524190606.GB20500@cvg>
References: <20070523184436.GA14771@cvg>
	<84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
	<20070524190606.GB20500@cvg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 23:06:06 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Pekka Enberg - Thu, May 24, 2007 at 09:47:42PM +0300]
> | Hi Cyrill,
> | 
> | On 5/23/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | >@@ -2103,7 +1944,7 @@ long udf_block_map(struct inode *inode, sector_t 
> | >block)
> | > 	kernel_lb_addr eloc;
> | > 	uint32_t elen;
> | > 	sector_t offset;
> | >-	struct extent_position epos = { NULL, 0, { 0, 0}};
> | >+	struct extent_position epos = {};
> | 
> | Bits like these in the middle of indentation fixes makes me feel
> | uneasy. Could we simply ask Andrew to run Lindent on the UDF sources
> | at some convinient point and push those to Linus like we did with
> | mm/slab.c if I recall correctly? Its safer to do cleanups like these
> | after that.
> | 
> 
> Dunno... Pekka, the patch I sent also added empty lines to separate
> some code block to be convenient to read. For some parts of code
> additinal 'if...else..' braces were added. Anyway even the code being
> formatted by linednt is to be reviewed manually I think. Anyway, your
> word Andrew?
> 

Such a patch should be whitespace-only: ideally it should generate an
identical .o file.  There may be legitimate reasons why the .o file
isn't identical, but we'd need to understand why that happened.  

The way to do this is as two patches (or two-per-C file):

1: feed foo.c through Lindent

2: manual fixups for places where Lindent went wrong.


<fiddles a bit>

OK, so I did

make kernel/sched.s
Lindent kernel/sched.c
make kernel/sched.s

and compared the two sched.s's:

--- kernel/sched.s      2007-05-24 12:25:40.000000000 -0700
+++ /tmp/sched.s        2007-05-24 12:25:16.000000000 -0700
@@ -1713,7 +1713,7 @@
        1:      ud2
 .pushsection __bug_table,"a"
 2:     .long 1b, .LC8  #
-       .word 4306, 0   #
+       .word 4308, 0   #
        .org 2b+12      #
 .popsection
 #NO_APP
@@ -1730,7 +1730,7 @@
        1:      ud2
 .pushsection __bug_table,"a"
 2:     .long 1b, .LC8  #
-       .word 4274, 0   #
+       .word 4276, 0   #
        .org 2b+12      #
 .popsection
 #NO_APP
@@ -2441,7 +2441,7 @@
 .L522:
        movl    $__func__.24446, %eax   #,
        movl    %eax, 12(%esp)  #,
-       movl    $1921, %eax     #,
+       movl    $1920, %eax     #,
        movl    %eax, 8(%esp)   #,
        movl    $.LC8, %eax     #,
        movl    %eax, 4(%esp)   #,
@@ -3855,7 +3855,7 @@
        1:      ud2
 .pushsection __bug_table,"a"
 2:     .long 1b, .LC8  #
-       .word 4078, 0   #
+       .word 4082, 0   #
        .org 2b+12      #
 .popsection
 #NO_APP


those differences are all due to changed line numbers, so we know that this
was a safe change.


