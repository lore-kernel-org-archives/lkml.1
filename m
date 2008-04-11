Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbYDKMpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbYDKMpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbYDKMpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:45:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44525 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbYDKMpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:45:30 -0400
Date: Fri, 11 Apr 2008 15:45:23 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: monstr@seznam.cz
cc: LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: microblaze: Merge window + git
In-Reply-To: <47FF42BE.8030005@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0804111537210.27699@wrl-59.cs.helsinki.fi>
References: <47FF183D.8060408@seznam.cz> <47FF42BE.8030005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Stefan Richter wrote:

> Michal Simek wrote:
> > Can you tell me when is open next merge window?
> 
> When 2.6.25 is being released.
> 
> > and my next question is about GIT.
> > 
> > I have second release at my git server and I have some changes which you
> > reported. I would like to collect all changes in the same set of patches.
> > 
> > I mean I have patch with 4 files and I did next changes. I would like to
> > integrate these changes to the same patches. Is it possible to do it?
> > It is easier to review all changes together.
> > 
> > I think it is no good way to send first release with reported bugs and new diffs.
> 
> You can combine several commits into one in a few ways.  Of course the
> combined commit is an entirely new one (with its own SHA1 etc.).  One
> possible way:
> 
> # you are at <commit0>
> $ git cherry-pick --no-commit <commit1>   # apply but don't commit yet
> $ git cherry-pick --edit <commit2>   # apply, edit the changelog, commit
> 
> There will now be a <commit3> whose parent is <commit0>.  <commit3>
> incorporates changes of <commit1> and <commit2>.
> 
> Another way:
> 
> # you are at <commit0>
> $ patch < ~/diff-from-somewhere
> $ git commit --amend   # replace <commit0> by new amended commit
> 
> There will now be a <commit4> instead of <commit0>, with the same
> parent(s) which <commit0> had.  <commit4> incorporates changes of
> <commit0> and the diff.

If you have a tree which has those four commits on top, it's rather easy 
with git:

$ git-reset --soft HEAD^^^
$ git-commit --amend

...In order the git-reset --soft to leave the index into the desired 
state, no pending stuff should be in index before beginning (index
is the thing controlled with cmds like git-add/git-update-index/etc.).

...The commit's message is taken from the bottommost of those four 
original commits.

-- 
 i.
