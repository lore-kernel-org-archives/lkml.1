Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZIGLVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZIGLVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZIGLVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZIGLV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:21:29 -0400
Subject: Re: [patch 09/33] fs: dcache scale dentry refcount
From: Eric Paris <eparis@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Eric Paris <eparis@parisplace.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090907074431.GH1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.281876981@nick.local0.net>
	 <7e0fb38c0909061101t6b4f337cvf691814c28bcf50e@mail.gmail.com>
	 <20090907074431.GH1875@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 07:21:21 -0400
Message-Id: <1252322481.2367.7.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 09:44 +0200, Nick Piggin wrote:
> On Sun, Sep 06, 2009 at 02:01:05PM -0400, Eric Paris wrote:
> > On Fri, Sep 4, 2009 at 2:51 AM, <npiggin@suse.de> wrote:
> > 
> > And yet in this case we do check for dentry->d_parent == dentry.  (my
> > unknowing self thinks we'd want to check in all places)
> 
> I think you're right, I think we need checks there too...
> 
> BTW Is there a way to test the fsnotify code? I thought inotify was
> supposed to be implemented with fsnotify, but I see quite a lot
> of duplicated (or very similar) code... We've also still got
> inotify calls in fs/ (inotify_umount_inodes). and CONFIG_INOTIFY and
> CONFIG_FSNOTIFY conditionals in there too. Would it be possible to
> move that out into fsnotify calls? (fsnotify_inode_init_once or
> whatever).
> 
> (Sorry to hijack your good review comments :))

Actually inotify.c in linux-next is dead code which I plan to remove
in .32.  In .31 inotify.c is used by the audit subsystem but inotify as
seen by userspace is implemented on top of fsnotify.

I'll try to pull down the whole patch series and test for any problems.

-Eric

