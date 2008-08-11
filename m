Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYHKSnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYHKSnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYHKSnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:43:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:18573 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYHKSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gipXjFLTEQ7ME914lEeEB4yXQ+6jlloUiJmEku4UFAhtAkBMMABMeTFx4ExpR3F5fq
         xG9h8qRxInaN/9ETuo7tyjV0GxbQiJdxwx46W2pPOuIrtuSEcaSzw6J7VvkBOmgJsSs1
         oTQBr0kkrOo7cWEk8/0Hc2ZzsV7YnlOAYT1LY=
Date: Mon, 11 Aug 2008 22:42:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811184257.GB18969@lenovo>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl> <20080811183300.GB9627@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811183300.GB9627@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Aug 11, 2008 at 08:33:00PM +0200]
| 
| * Rene Herman <rene.herman@keyaccess.nl> wrote:
| 
| > On 11-08-08 19:41, Ingo Molnar wrote:
| >
| >> * Rene Herman <rene.herman@keyaccess.nl> wrote:
| >
| >>> Ah, I was unaware of that difference, thank you. Ingo, can you 
| >>> replace  the previous incarnation with this one?
| >>
| >> sure - but some other commits were queued already so i've applied the  
| >> delta fix below.
| >
| > Thanks and fine ofcourse but from the Cheats 'R Us GIT handbook, when  
| > there's n patches on top of the one I want to edit:
| >
| > $ mkdir tmp
| > $ git format-patch -o tmp HEAD~n
| > $ git reset --hard HEAD~n
| > $ git reset --soft HEAD^
| > <fix>
| > $ git commit -a -c ORIG_HEAD
| > $ git am tmp/*
| > $ rm -rf tmp
| >
| > Just in case someone finds it interesting... :-)
| 
| i think something like this would do it as well:
| 
|     git-rebase -i HEAD~$[n+1]
| 
| Change the patch you want to edit from 'pick' to 'edit', and do a "git 
| commit --amend" to fix it up and then a "git rebase continue" to reapply 
| the other n patches ontop of the changed patch. (This is straight from 
| the Cheats 'R Us GIT handbook, second edition ;-)
| 
| The problem with rebasing though is that it does not interact with 
| normal Git workflows very nicely. Someone might have based further work 
| on those sha1's that we now change under them. When that further work is 
| backmerged later on we have overlapping sha1's.
| 
| There are two further specific non-Git-workflow arguments in favor of 
| the delta patch as well:
| 
| - in this case your first change was the obvious one and your NULL fix 
|   and your cleanup to the parameter expose a fundamental weakness of
|   early_param conversions - and i think highlighting that as separate 
|   commits might give someone ideas to improve the early_param() 
|   facility, if they see the fix patterns.

Ingo - I think the problem with early_param is not NULL itself but
rather - what is the right way to deal with boot params? I mean we
could pass empty string (not NULL) in case of argument absence _but_ would it
be the right way? If you remember when I sent first series for early_param
checking (and actually there are number of same issue exists for example
in s390 arch) - I was asking community what is the best way - since I'm not
that strong in interface engineering - i prefer fix the bugs :)

| 
| - Also, the NULL condition is obscure, so there's no bisection breakage
|   risk and it's the easiest for me to do append-only patches. The effort
|   and thought process you and Cyrill have put into it deserve a separate
|   commit as well anyway - and others might learn from it when looking at
|   logs.
| 
| 	Ingo
| 
		- Cyrill -
