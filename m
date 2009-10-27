Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZJ0BOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZJ0BOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZJ0BOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:14:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40507 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZJ0BOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:date
         :in-reply-to:message-id:lines:user-agent:mime-version:content-type;
        b=XdJXysRZUvqgtrquX306+e5lCvi6haVtyedDwr85kgMr6YXcT9MW+SWT4bU/Fq4EEW
         81Yi46KLFlO0TsqCNRllVkwv3tqTP08UbzAZ+g7ZVRv6aGaK/pUKnZW5LiayeJ4EmkR6
         HN27mxpsGW7jFGE4sbnJjrOdS94C1bG1buMHc=
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, git <git@vger.kernel.org>,
       mercurial@selenic.com, Marti Raudsepp <marti@juffo.org>
Subject: Re: git vs hg commit counts?
References: <1256602127.29938.8.camel@Joe-Laptop.home>
From: Jakub Narebski <jnareb@gmail.com>
Date: Mon, 26 Oct 2009 18:14:43 -0700 (PDT)
In-Reply-To: <1256602127.29938.8.camel@Joe-Laptop.home>
Message-ID: <m3zl7dd4g6.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> I'm comparing linux-kernel git vs hg repositories.
> 
> While testing some changes to scripts/get_maintainer.pl,
> I noticed that git and hg have different commit counts
> for the same files.
> 
> For instance:
> 
> $ git log --since=1-year-ago -- MAINTAINERS | \
> 	grep -P "^commit [0-9a-f]{40,40}$"  | wc -l
> 514
> 
> $ hg log --template="commit {node}\n" --date -365 -- MAINTAINERS  | \
> 	grep -P "^commit [0-9a-f]{40,40}$" | wc -l
> 601
> 
> Anyone have any understanding why?

It *might* be caused by the fact that in Mercurial commit can have
only up to two parents.  This means that octopus merges (merge commits
with more than two parents: there are a few of them in linux-kernel
history) have to be represented as a set of two-parent merges.

-- 
Jakub Narebski

http://stackoverflow.com/questions/1598759/git-and-mercurial-compare-and-contrast/1599930#1599930
