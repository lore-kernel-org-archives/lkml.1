Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbYCCDnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbYCCDnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYCCDnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:43:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:30808 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYCCDnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YppswvagIaHAhYE/QbKRwjO9V34/scIIvwzlWnh/nwGzXdLtHQNcSDxoMHo8cu4lAXy4sT2ek2JOzlwdydQPDq/MzFfhLcPjNWmHcGZ2+0oLMEbgq67P0v8zR33qchj1Y3D4XiSZ6zL28aAe+WmLKhAt6bL4W8DcWcRpXCwQoFc=
Message-ID: <524f69650803021943i33ce6ddbo309f118cd0a77ac9@mail.gmail.com>
Date: Sun, 2 Mar 2008 21:43:39 -0600
From: "Steve French" <smfrench@gmail.com>
To: git@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org git tree corrupt?
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803021302070.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650803020749o469f2e48l125a55267b0b5d13@mail.gmail.com>
	 <alpine.LFD.1.00.0803021302070.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 3:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  On Sun, 2 Mar 2008, Steve French wrote:
>  >
>  > In preparation for a merge request I do
>  >     cg-diff -m -r origin: | diffstat -p1
>  > (git diff -m -r origin: shows the same problem) and
>  >     cg-log -m -r origin:
>
>  First off, you really should lay off the cogito thing
no problem

>   - look at your .git/config file to make sure that the remote branches are
>    sane. It should have something like this (and if it doesn't, add it):
>
>         [remote "origin"]
>                 url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
>                 fetch = +refs/heads/*:refs/remotes/origin/*
>
>         [branch "master"]
>                 remote = origin
>                 merge = refs/heads/master
.git/config now includes

[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = /pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master


>   - look at your "origin" branch, and make sure it's a *remote* branch, not
>    the old-style local one. Ie it should *not* show up when you do a
>    plain
>
>         git branch
now only shows "* master"

>    but it *should* show up (as both "origin/HEAD" and "origin/master")
>    when you do
>
>         git branch -a
Now "git branch -a" shows
* master
  origin/master

It is missing "origin/HEAD"
>   - now do "git log origin" an it should show something recent
git log origin and git log origin/master both return
"ambiguous argument 'origin': unknown revision"

I must be misunderstanding the syntax/manpage of git-log but "git diff
-m -r origin/master"
now works fine and displays exactly what I expect so things have improved.



>  Now your setup should be ok again. I *suspect* that what has happened is
>  that you got a local "origin" branch - probably through cogito - that hid
>  the remote one.
This seems plausible and


-- 
Thanks,

Steve
