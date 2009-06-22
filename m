Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZFVT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZFVT5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZFVT5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:57:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZFVT5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:57:11 -0400
Date: Mon, 22 Jun 2009 12:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Mindalev <r000n@r000n.net>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [2.6.30-02327-g8ebf975] idr_remove called for id=68 which is
 not allocated.
Message-Id: <20090622125618.ac86d345.akpm@linux-foundation.org>
In-Reply-To: <20090612164517.3e27a0ef@desktop.r000n.info>
References: <20090612164517.3e27a0ef@desktop.r000n.info>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 16:45:17 +0400
Roman Mindalev <r000n@r000n.net> wrote:

> Hi. I'm updated to 2.6.30-git3 today.
> Box running normally hour or two. But after any process can't to be
> running. It's started from this line in log: 
> 
> [ 3077.464204] idr_remove called for id=68 which is not allocated.
> 
> Traces from processes like this:
> 
> Jun 12 15:40:04 desktop kernel: [ 3077.464215] Pid: 8921, comm: udevd
> Tainted: G        W  2.6.30-02327-g8ebf975 #1
> Jun 12 15:40:04 desktop kernel: [ 3077.464221] Call Trace:
> Jun 12 15:40:04 desktop kernel: [ 3077.464237]  [<ffffffff812b9faf>]
> idr_remove+0x7f/0x200
> Jun 12 15:40:04 desktop kernel: [ 3077.464247]  [<ffffffff8148a90d>] ?
> _spin_lock+0x6d/0x80
> Jun 12 15:40:04 desktop kernel: [ 3077.464258]  [<ffffffff811568a2>] ?
> inotify_destroy_mark_entry+0xb2/0xf0
> Jun 12 15:40:04 desktop kernel: [ 3077.464267]  [<ffffffff811568b6>]
> inotify_destroy_mark_entry+0xc6/0xf0
> Jun 12 15:40:04 desktop kernel: [ 3077.464277]  [<ffffffff81155bce>]
> inotify_freeing_mark+0xe/0x10
> Jun 12 15:40:04 desktop kernel: [ 3077.464285]  [<ffffffff81153fff>]
> fsnotify_destroy_mark_by_entry+0x13f/0x1a0
> Jun 12 15:40:04 desktop kernel: [ 3077.464295]  [<ffffffff81156833>]
> inotify_destroy_mark_entry+0x43/0xf0
> Jun 12 15:40:04 desktop kernel: [ 3077.464304]  [<ffffffff81156977>]
> sys_inotify_rm_watch+0x97/0xf0
> Jun 12 15:40:04 desktop kernel: [ 3077.464315]  [<ffffffff8100b6db>]
> system_call_fastpath+0x16/0x1b
> Jun 12 15:40:04 desktop kernel: [ 3077.472929] PGD 1003067 PUD 0 
> Jun 12 15:40:04 desktop kernel: [ 3077.472958] CPU 1 
> Jun 12 15:40:04 desktop kernel: [ 3077.472963] Modules linked in:

Thanks.  Eric has recently merged a patch which should fix this
("inotify: inotify_destroy_mark_entry could get called twice").  Please
retest Linus's current tree?

