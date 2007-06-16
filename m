Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXFPEH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXFPEH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXFPEHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 00:07:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:24317 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750708AbXFPEHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 00:07:48 -0400
Date: Sat, 16 Jun 2007 06:07:47 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
Message-ID: <20070616040747.GA21076@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Daniel Barkalow <barkalow@iabervon.org>,
	linux-kernel@vger.kernel.org
References: <20070616001255.GA11403@alinoe.com> <Pine.LNX.4.64.0706152026320.4740@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706152026320.4740@iabervon.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 08:33:38PM -0400, Daniel Barkalow wrote:
> HEAD doesn't mean what you think it means. It's the latest revision on the 
> branch with the *. What you want is:
> 
> $ git checkout master
> 
> This will move the * to "master", which shouldn't have been affected by 
> any of this, and move your working directory to this point as well. At 
> that point, you should be able to build a working kernel.
> 
> What "git reset --hard HEAD" does is discard any differences to tracked 
> files between your working directory and the revision you're on. It's 
> relevant if you want to discard local changes, not otherwise.

I don't understand - any branch that I am on has many tags. I can use
'git reset --hard sometag' to change the source tree to that tag (which
works if I look at the version in the Makefile and pick tags that are
far apart enough). Then, shouldn't 'HEAD' have the meaning: the newest
tag on the branch? I was on the 'bisect' branch - but that is a copy
of the master, no? At least, that was what I started on when I started
the bisect.

Anyway, I tried this:

$ git checkout master
$ git branch
  bisect
* master
  origin
$ BRANCH=$(git branch | grep "^\*" | sed -e "s/\* //")
$ echo $BRANCH
master
$ git rev-list --max-count=1 $BRANCH
5ecd3100e695228ac5e0ce0e325e252c0f11806f

Is it correct that this last command gives me the 'git id' (if that
is the correct name for the hash) of the revision that my local
working copy is at?

Can you tell me what is the latest git id that you see?

Because, if I compile 5ecd3100e695228ac5e0ce0e325e252c0f11806f is
still hangs at boot :(

I really don't know how I got a working kernel before :/

-- 
Carlo Wood <carlo@alinoe.com>
