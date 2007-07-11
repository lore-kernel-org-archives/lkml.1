Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbXGKMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbXGKMYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbXGKMYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:24:09 -0400
Received: from verein.lst.de ([213.95.11.210]:55027 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbXGKMYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:24:08 -0400
Date: Wed, 11 Jul 2007 14:23:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, linux-mm@kvack.org
Subject: lguest, Re: -mm merge plans for 2.6.23
Message-ID: <20070711122324.GA21714@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> lguest-export-symbols-for-lguest-as-a-module.patch

__put_task_struct is one of those no way in hell should this be exported
things because we don't want modules messing with task lifetimes.

Fortunately I can't find anything actually using this in lguest, so
it looks the issue has been solved in the meantime.


I also have a rather bad feeling about exporting access_process_vm.
This is the proverbial sledge hammer for access to user vm addresses
and I'd rather keep it away from module programmers with "if all
you have is a hammer ..." in mind.

In lguest this is used by send_dma which from my short reading of the
code seems to be the central IPC mechanism.  The double copy here
doesn't look very efficient to me either.  Maybe some VM folks could
look into a better way to archive this that might be both more
efficient and not require the export.


> lguest-the-guest-code.patch
> lguest-the-host-code.patch
> lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
> lguest-the-asm-offsets.patch
> lguest-the-makefile-and-kconfig.patch
> lguest-the-console-driver.patch
> lguest-the-net-driver.patch
> lguest-the-block-driver.patch
> lguest-the-documentation-example-launcher.patch

Just started to reading this (again) so no useful comment here, but it
would be nice if the code could follow CodingStyle and place the || and
&& at the end of the line in multiline conditionals instead of at the
beginning of the new one.
