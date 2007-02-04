Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbXBDK0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbXBDK0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXBDK0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:26:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42014 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXBDK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:26:34 -0500
Date: Sun, 4 Feb 2007 10:26:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070204102629.GA8785@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management <linux-mm@kvack.org>
References: <20070204063707.23659.20741.sendpatchset@linux.site> <20070204063833.23659.55105.sendpatchset@linux.site> <20070204014445.88e6c8c7.akpm@linux-foundation.org> <20070204101529.GA22004@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070204101529.GA22004@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 11:15:29AM +0100, Nick Piggin wrote:
> Cool, a kernel thread is calling sys_write. Fun.

There are tons of places where we possible call into ->write from
either kernel threads or at least with a kernel pointer  and set_fs/set_ds
magic.  Anything in the buffer write path that tries to touch page tables
can't work.

