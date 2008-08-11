Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYHKSy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYHKSy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYHKSyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:54:40 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55966 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYHKSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:54:39 -0400
Message-ID: <48A08AFA.80105@keyaccess.nl>
Date: Mon, 11 Aug 2008 20:54:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl> <20080811183300.GB9627@elte.hu>
In-Reply-To: <20080811183300.GB9627@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-08 20:33, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:

>> Thanks and fine ofcourse but from the Cheats 'R Us GIT handbook, when  
>> there's n patches on top of the one I want to edit:
>>
>> $ mkdir tmp
>> $ git format-patch -o tmp HEAD~n
>> $ git reset --hard HEAD~n
>> $ git reset --soft HEAD^
>> <fix>
>> $ git commit -a -c ORIG_HEAD
>> $ git am tmp/*
>> $ rm -rf tmp
>>
>> Just in case someone finds it interesting... :-)
> 
> i think something like this would do it as well:
> 
>     git-rebase -i HEAD~$[n+1]
> 
> Change the patch you want to edit from 'pick' to 'edit', and do a "git 
> commit --amend" to fix it up and then a "git rebase continue" to reapply 
> the other n patches ontop of the changed patch. (This is straight from 
> the Cheats 'R Us GIT handbook, second edition ;-)

Okay, okay, okay, so nobody found it interesting. Got the same bit of 
advice in private approximately 2 seconds after sending... ;-)

Thanks to both though. And now that you mention it, I remember actually 
having gotten the rebase -i advice earlier but it had slipped my mind 
again. Just tried it and it works nicely.

> The problem with rebasing though is that it does not interact with 
> normal Git workflows very nicely. Someone might have based further work 
> on those sha1's that we now change under them. When that further work is 
> backmerged later on we have overlapping sha1's.

Yes, I'm endpoint.

> There are two further specific non-Git-workflow arguments in favor of 
> the delta patch as well:
> 
> - in this case your first change was the obvious one and your NULL fix 
>   and your cleanup to the parameter expose a fundamental weakness of
>   early_param conversions - and i think highlighting that as separate 
>   commits might give someone ideas to improve the early_param() 
>   facility, if they see the fix patterns.

On that note, I sort of wonder why there is an early_param(). As in, not 
just a kernel_param(). Does __setup() have fundamental advantages over 
early_param()?

> - Also, the NULL condition is obscure, so there's no bisection breakage
>   risk and it's the easiest for me to do append-only patches. The effort
>   and thought process you and Cyrill have put into it deserve a separate
>   commit as well anyway - and others might learn from it when looking at
>   logs.

(true, I neglected to point out Cyrill's bug catching)

Rene
