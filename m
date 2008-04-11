Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYDKKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYDKKwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbYDKKw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:52:26 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34407 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbYDKKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:52:25 -0400
Message-ID: <47FF42BE.8030005@s5r6.in-berlin.de>
Date: Fri, 11 Apr 2008 12:51:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: monstr@seznam.cz
CC: linux-kernel@vger.kernel.org
Subject: Re: microblaze: Merge window + git
References: <47FF183D.8060408@seznam.cz>
In-Reply-To: <47FF183D.8060408@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Can you tell me when is open next merge window?

When 2.6.25 is being released.

> and my next question is about GIT.
> 
> I have second release at my git server and I have some changes which you
> reported. I would like to collect all changes in the same set of patches.
> 
> I mean I have patch with 4 files and I did next changes. I would like to
> integrate these changes to the same patches. Is it possible to do it?
> It is easier to review all changes together.
> 
> I think it is no good way to send first release with reported bugs and new diffs.

You can combine several commits into one in a few ways.  Of course the
combined commit is an entirely new one (with its own SHA1 etc.).  One
possible way:

# you are at <commit0>
$ git cherry-pick --no-commit <commit1>   # apply but don't commit yet
$ git cherry-pick --edit <commit2>   # apply, edit the changelog, commit

There will now be a <commit3> whose parent is <commit0>.  <commit3>
incorporates changes of <commit1> and <commit2>.

Another way:

# you are at <commit0>
$ patch < ~/diff-from-somewhere
$ git commit --amend   # replace <commit0> by new amended commit

There will now be a <commit4> instead of <commit0>, with the same
parent(s) which <commit0> had.  <commit4> incorporates changes of
<commit0> and the diff.

However, I am no expert on doing these things in git since I only
develop with quilt.  I use git only to publish the state of development
and the state for upstream merge.
-- 
Stefan Richter
-=====-==--- -=-- -=-==
http://arcgraph.de/sr/
