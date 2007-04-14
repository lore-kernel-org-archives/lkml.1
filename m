Return-Path: <linux-kernel-owner+w=401wt.eu-S1030838AbXDNGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030838AbXDNGYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030817AbXDNGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:24:22 -0400
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:46523 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030746AbXDNGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:24:21 -0400
From: Junio C Hamano <junkio@cox.net>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
References: <46206842.80203@gmail.com>
Date: Fri, 13 Apr 2007 23:24:19 -0700
In-Reply-To: <46206842.80203@gmail.com> (Rene Herman's message of "Sat, 14 Apr
	2007 07:36:02 +0200")
Message-ID: <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> writes:

> Stumbling around with git here. I'd like to use git to efficiently
> track the current -stable as well as -current. Say, my local tree is a
> clone of Linus current:
>
> git clone \
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> local
>
> I then branch off a 2.6.20 branch:
>
> cd local
> git checkout -b v2.6.20 v2.6.20
>
> to now update to the current -stable I could do:
>
> git pull \
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

I think adding these lines to .git/config would do the trick,
after you have done the "checkout -b v2.6.20 v2.6.20" step:

[branch "v2.6.20"]
	remote = stable
	merge = refs/heads/master
[remote "stable"]
	url = git://git.kernel.org/.../stable/linux-2.6.20.y.git
	fetch = refs/heads/master

provided if stable team forks v2.6.20.y history off of Linus's
v2.6.20.

With the above configuration, anytime you say "git pull" while
on your v2.6.20 branch will fetch from "stable" and merge their
'master' branch in your current branch (i.e. v2.6.20 branch).

