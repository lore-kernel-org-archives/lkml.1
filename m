Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXA3XVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXA3XVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXA3XVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:21:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXA3XV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:21:29 -0500
Date: Tue, 30 Jan 2007 15:21:19 -0800
From: Andrew Morton <akpm@osdl.org>
To: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-Id: <20070130152119.e0a18e58.akpm@osdl.org>
In-Reply-To: <20070130125558.ae9119b0.akpm@osdl.org>
References: <20070129081905.23584.97878.sendpatchset@linux.site>
	<20070130125558.ae9119b0.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 12:55:58 -0800
Andrew Morton <akpm@osdl.org> wrote:

> y'know, four or five years back I fixed this bug by doing
> 
> 	current->locked_page = page;
> 
> in the write() code, and then teaching the pagefault code to avoid locking
> the same page.  Patch below.
> 
> But then evil mean Hugh pointed out that the patch is still vulnerable to
> ab/ba deadlocking so I dropped it.

And he was right, of course.  Task A holds file a's i_mutex and takes a
fault against file b's page.  Task B holds file b's i_mutex and takes a
fault against file a's page.  Drat.

I wonder if there's a sane way of preventing that.
