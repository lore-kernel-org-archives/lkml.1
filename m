Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbYB0Agt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbYB0Agt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764766AbYB0Ag1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:36:27 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53849 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764238AbYB0Ag0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:36:26 -0500
Date: Tue, 26 Feb 2008 17:36:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: [PATCHES] semaphore rewrite
Message-ID: <20080227003605.GC5715@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a series of twelve patches to introduce down_killable().  I expect
the first ten to be uncontroversial, and easy to apply.  The last two
... I'm still testing.  More testers would be welcome, particularly
people who have performance test-suites they wouldn't want to see regress.

The way I go about introducing down_killable is to replace all the
carefully hand-tuned assembler with a generic C implementation.  One of
the annoying things about this is that the header file is in
asm/semaphore.h instead of linux/semaphore.h.  I tackle this by removing
all the obsolete inclusions of asm/semaphore.h (around 100 of them).
In order for that to work, I actually need to add a couple in places
where they were being implicitly included.

Then I replace the per-arch implementations with a generic one.  All the
<asm/semaphore.h> files become a one-line include of linux/sempahore.h.

Then all remaining users in the tree are converted to use
linux/semaphore.h.

I add 'removal of asm/semaphore.h' to features-removal to not inflict
extra pain on Andrew during this process.

So, to recap:

Patches 1 -  2: Add missing includes
Patches 3 - 10: Remove obsolete includes (split up by top-level directory)
Patch       11: Generic semaphore implementation
Patch       12: Switch remaining users to linux/semaphore.h

I hope this split causes the least amount of pain.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
