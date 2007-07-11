Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbXGKSFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbXGKSFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbXGKSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:05:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759057AbXGKSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:05:19 -0400
Date: Wed, 11 Jul 2007 11:04:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, linux-mm@kvack.org
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
Message-Id: <20070711110453.c4020526.akpm@linux-foundation.org>
In-Reply-To: <20070711122324.GA21714@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711122324.GA21714@lst.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 14:23:24 +0200
Christoph Hellwig <hch@lst.de> wrote:

> > lguest-export-symbols-for-lguest-as-a-module.patch
> 
> __put_task_struct is one of those no way in hell should this be exported
> things because we don't want modules messing with task lifetimes.
> 
> Fortunately I can't find anything actually using this in lguest, so
> it looks the issue has been solved in the meantime.
> 

Ther are a couple of calls to put_task_struct() in there, and that needs
__put_task_struct() exported.

> 
> I also have a rather bad feeling about exporting access_process_vm.
> This is the proverbial sledge hammer for access to user vm addresses
> and I'd rather keep it away from module programmers with "if all
> you have is a hammer ..." in mind.

hm, well, access_process_vm() is a convenience wrapper around
get_user_pages(), whcih is exported.

> In lguest this is used by send_dma which from my short reading of the
> code seems to be the central IPC mechanism.  The double copy here
> doesn't look very efficient to me either.  Maybe some VM folks could
> look into a better way to archive this that might be both more
> efficient and not require the export.
> 
> 
> > lguest-the-guest-code.patch
> > lguest-the-host-code.patch
> > lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
> > lguest-the-asm-offsets.patch
> > lguest-the-makefile-and-kconfig.patch
> > lguest-the-console-driver.patch
> > lguest-the-net-driver.patch
> > lguest-the-block-driver.patch
> > lguest-the-documentation-example-launcher.patch
> 
> Just started to reading this (again) so no useful comment here, but it
> would be nice if the code could follow CodingStyle and place the || and
> && at the end of the line in multiline conditionals instead of at the
> beginning of the new one.
