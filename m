Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbXJXT64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbXJXT64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbXJXT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:58:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36459 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbXJXT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:58:48 -0400
Date: Wed, 24 Oct 2007 13:58:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Stringbuf, v2
Message-ID: <20071024195847.GE27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Incorporated all feedback received:

 - Explicitly allow people to dereference sb->buf and sb->len, and include
   comments about the potential problems with doing so.  Document that alloc
   is probably better left unreferenced.  Remove sb_len() and sb_string().
 - Ensure that we grow by at least 1.5x, even if we're using slob.
 - Start by allocating 128 bytes
 - Pass a gfp_t to sb_printk
 - Drop the bogus change to snd_ac97_proc_regs_write
 - Add stringbuf.o to obj-y instead of lib-y, otherwise a fully modular kernel
   might not pull in sb_printf

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
