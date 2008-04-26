Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYDZOSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYDZOSK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYDZORo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:17:44 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:38718 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYDZORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:17:42 -0400
Date: Sat, 26 Apr 2008 16:17:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: viro@ZenIV.linux.org.uk, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: mainline boot failures II: getname -> kmem_cache_alloc oops
Message-ID: <20080426141739.GA13641@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Apr 2008 14:10:48.0627 (UTC) FILETIME=[53BC1030:01C8A7A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI

I see lots of boot failures on various setups with current mainline
(git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately
they are all different.

Here's one on a two socket box:

Only paraphrased oops because serial died on that box, but it is 
roughly:

BUG unable to handle kernel paging request at ffff81091fc09c6e
IP: ... kmem_cache_alloc+0x5d/0xb2

(most of them are bogus of course - a kingdom for the dwarf2 unwinder)

child_rip->kernel_init->child_rip->compat_clock_nanosleep_restart->
kernel_init->populate_rootfs->unpack_to_rootfs->flush_window->write_buffer->
do_name->do_header->__drain_alien_cache->sys_chown->__user_walk_fd->getname

-Andi
