Return-Path: <linux-kernel-owner+w=401wt.eu-S936183AbXHNV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936183AbXHNV72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934479AbXHNVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:40:46 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42221 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818AbXHNVkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:40:42 -0400
Date: Tue, 14 Aug 2007 17:40:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/14] UML - Get rid of tt mode
Message-ID: <20070814214016.GA17320@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches is 2.6.24 material.

It throws out tt mode, which has been non-functional for a while.

This is done in phases, interspersed with code cleanups on the
affected files.

The removal is done as follows:
	remove all code, config options, and files which depend on
CONFIG_MODE_TT
	get rid of the CHOOSE_MODE macro, which decided whether to
call tt-mode or skas-mode code, and replace invocations with their
skas portions
	replace all now-trivial procedures with their skas equivalents

There are now a bunch of now-redundant pieces of data structures,
including mode-specific pieces of the thread structure, pt_regs, and
mm_context.  These are all replaced with their skas-specific contents.

As part of the ongoing style compliance project, I made a style pass
over all files that were changed.  There are three such patches, one
for each phase, covering the files affected by that phase but no later
ones.

I noticed that we weren't freeing the LDT state associated with a
process when it exited, so that's fixed in one of the later patches.

The last patch is a tidying patch which I've had for a while, but
which caused inexplicable crashes under tt mode.  Since that is no
longer a problem, this can now go in.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
