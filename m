Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZANDsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZANDsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZANDsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:48:11 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2955 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbZANDsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:48:09 -0500
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20090113125435.4821123a.akpm@linux-foundation.org>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <20090113125435.4821123a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 19:49:02 -0800
Message-Id: <1231904942.7935.486.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 12:54 -0800, Andrew Morton wrote:
> I applaud the intent.
> This patchset is basically unmergeable by anyone except Linus - it
> already gets three rejects against half-hour-old mainline.

True.

> How does it work, anyway?

Find a section/file match by pattern.
If --git set (default), find the git "by: " signees by file.
It uses the equivalent of what Linus posted quite a while back.

+sub recent_git_signoffs {
+    my ($file) = @_;
+
+    my $sign_offs = "";
+    my $cmd = "";
+    my $output = "";
+
+    my @lines = ();
+
+    if (which("git") eq "") {
+       die("$P: git not found.  Add --nogit to options?\n");
+    }
+
+    $cmd = "git log --since=12.months.ago -- ${file}";
+    $cmd .= " | grep -i '^    [-a-z]*by:.*\\\@'";
+    if (!$email_git_penguin_chiefs) {
+       $cmd .= " | grep -E -v \"${penguin_chiefs}\"";
+    }
+    $cmd .= " | sort | uniq -c | sort -r -n | head -n 5";
+    $cmd .= " | cut -f 2 -d ':' -s";


> akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f mm/filemap.c 
> Balbir Singh <balbir@linux.vnet.ibm.com>
> Hugh Dickins <hugh@veritas.com>
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Miklos Szeredi <mszeredi@suse.cz>
> Nick Piggin <npiggin@suse.de>
> 
> I think Balbir would be surprised!

$ scripts/get_maintainer.pl --nogit -f mm/filemap.c
linux-kernel@vger.kernel.org
linux-mm@kvack.org

> akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f fs/ext3/super.c
> Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Christoph Hellwig <hch@lst.de>
> Jan Blunck <jblunck@suse.de>
> Jan Kara <jack@suse.cz>
> Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> mm..  spose so, but it isn't terribly accurate.  Does it take
> signed-off-by:s and/or the git Commit: header into account?

Just the most frequent and top 5 "by:" signees for the last year.

$ scripts/get_maintainer.pl --nogit -f fs/ext3/super.c
Andreas Dilger <adilger@sun.com>
Andrew Morton <akpm@linux-foundation.org>
Stephen Tweedie <sct@redhat.com>
linux-ext4@vger.kernel.org

> akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f fs/xfs/xfs.h   
> Christoph Hellwig <hch@infradead.org>
> Donald Douwsma <donaldd@sgi.com>
> Eric Sandeen <sandeen@sandeen.net>
> Lachlan McIlroy <lachlan@sgi.com>
> Tim Shimmin <tes@sgi.com>
> 
> OK, that was an easy case.

$ scripts/get_maintainer.pl --nogit -f fs/xfs/xfs.h
Tim Shimmin <xfs-masters@oss.sgi.com>
xfs@oss.sgi.com


> It's a bit slow.  That's git's fault.  Perhaps some git person will be
> able to suggest ways of speeding it up.

Don't use git?  Add --nogit?

> akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f mm/pdflush.c 
> Ingo Molnar <mingo@elte.hu>
> Jesper Juhl <jesper.juhl@gmail.com>
> Mike Travis <travis@sgi.com>
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Pavel Machek <pavel@suse.cz>
> 
> again, not the result I'd have expected!

$ scripts/get_maintainer.pl --nogit -f mm/pdflush.c 
linux-kernel@vger.kernel.org
linux-mm@kvack.org

> But I guess we can fine-tune these thnigs after we get the bulk of it
> settled in.
> My script generates what I consider to be better results:

[script...]

I have no problem changing the get_maintainer.pl script to use
only the "author:" instead of the signees.

My desire is to add the file patterns themselves.

