Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXJBWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXJBWU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXJBWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:20:18 -0400
Received: from waste.org ([66.93.16.53]:33024 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXJBWUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:20:17 -0400
Date: Tue, 2 Oct 2007 17:20:03 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: pgd_none_or_clear_bad strangeness?
Message-ID: <20071002222003.GL19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In lib/pagewalk.c, I've been using the various forms of
{pgd,pud,pmd}_none_or_clear_bad while walking page tables as that
seemed the canonical way to do things. Lately (eg with -rc7-mm1),
these have been triggering messages like "bad pgd 0x01e3" and causing
nasty double faults. It appears this is actually triggered at the pmd
level (mm/memory.c:116), though it appears to produce the wrong
message.

Has something changed here? I'm pretty sure this used to work! Is this
not a kosher thing to do? Does it make any sense I'd repeatedly run
into a bad pmd in the middle of bash's page table right after boot?
The simple _none variant seems to work, but I worry that it's papering
over a real problem.

-- 
Mathematics is the supreme nostalgia of our time.
