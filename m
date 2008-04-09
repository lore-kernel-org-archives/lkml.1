Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYDITGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYDITGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYDITGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:06:38 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:4585 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYDITGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:06:37 -0400
Message-ID: <47FD1397.5000906@linuxtv.org>
From: mkrufky@linuxtv.org
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT
	ION__ occurences
Date: Wed, 9 Apr 2008 15:05:59 -0400 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <1207765825.16220.16.camel@brick>
x-originalarrivaltime: 09 Apr 2008 19:04:13.0308 (UTC) FILETIME=[7FEB73C0:01C89A74]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2008-04-09 at 13:00 -0400, Michael Krufky wrote:
>   
>> On Fri, Apr 4, 2008 at 11:09 AM, Michael Krufky <mkrufky@linuxtv.org> 
>> Harvey,
>>
>> I have received your entire patchset.  Some patches have already been
>> merged into our development tree, others have been dropped, since some
>> of individual driver maintainers have decided to remove the
>> __FUNCTION__ macro from their source code altogether, rather than
>> accept this change.
>>
>> I have merged the remaining pending patches into a mercurial tree,
>> hosted on linuxtv.org:
>>
>> http://linuxtv.org/hg/~mkrufky/function-func
>>
>> Please note that I had to manually apply patches 8, 11 and 13, since
>> you generated your changes against the git repository rather than the
>> official v4l-dvb development repository hosted on linuxtv.org.
>>     
>
> I don't know/use mercurial, sorry, I thought git-v4l's devel branch on
> kernel.org would be a mirror of the development tree...guess I was
> mistaken
>   

The v4l-dvb git tree is where changesets go before Mauro requests a 
merge to Linus.  This repository is usually months behind the current 
development tree, and for good reason.

Mauro's 'devel' branch is relatively close to the mercurial repository, 
however, in the mercurial repository we maintain backwards compatibility 
that usually goes back at least a few kernel versions.  In order to 
support that compatibility, there are extra #ifdef compiler directives 
in that source tree, which is stripped away before merging to -git.

When large patches come in based on the git repositories, a large amount 
of manual application is needed in order to merge properly.  This is 
usually only an issue for large, frivolous coding style changes.  Most 
functional patches never hit this issue.

>> I must stress this -- all v4l-dvb patches, ESPECIALLY
>> codingstyle-cleanups (due to the nature of those patches, touching
>> many many files at once), should always be generated against the
>> v4l-dvb master development repository hosted on linuxtv.org.
>>
>> Now, I have a question.....
>>
>> About this change from __FUNCTION__ to __func__ , I understand that
>> this change is being done kernel-wide.  At first, I had blindly
>> accepted this change as a kernel-janitor "cleanup", until it was
>> pointed out to me last night, that older compilers do not support
>> __func__.  Sure, one can always do the following for compat:
>>
>> #ifndef __func__
>>  #define __func__ __FUNCTION__
>> #endif /* __func__ */
>>     
>
> This is already done in kernel.h, so __func__ is already being passed to
> any compiler used on the kernel....
>
> /* Trap pasters of __FUNCTION__ at compile-time */
> #define __FUNCTION__ (__func__)
>   

You misunderstood me.  I was talking about how people can compile the 
sources using __func__ rather than __FUNCTION__ using older compilers 
that do not support __func__.

Meanwhile -- you just pointed out this trap, above.  If that is already 
in kernel.h, then why replace all actual occurences of __FUNCTION__ with 
__func__ across the kernel tree?  That trap allows your cleanup to take 
affect in the compiled binaries, while NOT forcing this change on the 
subsystem kernel code.

The v4l-dvb tree is used outside of the kernel as well as within the 
kernel, and we like to support additional configurations that are not 
necessarily supported in-kernel.

This conversion "cleanup" is starting to sound less and less 
attractive.  Was there ever a discussion & agreement about this on LKML??

>   
>> ...but the question is raised, why are we making this change in the first
place?
>>
>> Don't get me wrong -- as I said before, I understand that this change
>> is kernel-wide, and I am not arguing against it.  I will continue on
>> to have this merged into 2.6.26.  I would just like to see a link that
>> points to a discussion thread on LKML that explains the reasons for
>> this change, and where this change was globally agreed to.  Again -- I
>> am not challenging these patches.  I merely want to read more
>> information as to why we are making this move.
>>     

I'm guessing that this discussion never actually took place?

>> In the meanwhile, below is the checkpatch.pl fallout after applying
>> your __FUNCTION__ to __func__ series.  Since you are working on these
>> codingstyle cleanups anyway, I'd imagine that you won't mind fixing
>> these checkpatch.pl "errors" and "warnings" before we merge these
>> changes.
>>     
>
> For such a large set in v4l, it's a drastic increase in work to do so
> in this case as it is a simple sed s/__FUNCTION__/__func__/
>   

Please see my comments at the end of this email.

>   
>> I understand if you don't want to alter code that you may not be
>> directly involved in, but I am sure you will have no trouble at least
>> fixing the "comma after space" and "line over 80 characters" cases.
>>
>> Please generate the additional cleanups against the mercurial tree
>> that I merged your previous series to:
>>
>> http://linuxtv.org/hg/~mkrufky/function-func
>>     
>
> Do you have a git mirror somewhere?
>   

No.  A git mirror would not help in this case, since we would need to 
merge the changes back into the mercurial repository before the changes 
waiting there go to -git.

>   
>> Also, please generate the codingstyle cleanup patches individually
>> based on the directory structure, just as you did in your last series.
>>
>> See below for the checkpatch.pl "errors" and "warnings".
>>     
>
> I can't say I have much enthusiasm for that, but if you'd really want
> such a patch, I will try to get to it this week.
It's not that I "really want such a patch" -- rather, I am merely 
reacting in the same manner that has been done in the past.

For example:

Quite often the case arises where a user reports an OOPS, or some other 
bug in the current code.  A developer will fix the bug, and send in a 
patch to fix it.  The maintainer of our subsystem then proceeds to NACK 
the bug-fix patch, because it fails checkpatch.pl.

I disagree with this policy, however, this is the policy.  I always felt 
that patches should be small, and only attack one specific item.  I have 
always agreed with akpm's "The Perfect Patch" document, where no two 
changes should ever appear in the same patch. ie:  if there is a 
codingstyle / whitespace cleanup, it should appear in a separate patch, 
rather than a patch that fixes a bug or adds new functionality.

Ever since the appearance of checkpatch.pl, now all patches that fix 
real bugs get nacked unless they themselves pass checkpatch.pl's 
"requirements".  The patch must be re-worked, or an additional patch 
must be submitted, that removes any codingstyle issue detected by the 
original patch, even if it is caused by a piece of code that had already 
existed.

In summary, I as a developer, am made aware of bugs in the kernel, and I 
like to fix them when I can.  When I submit a bug-fix patch that alters 
a line that has comma's without spaces afterwards, my patch is nacked, 
until I fix the codingstyle issue as well, even though the codingstyle 
issue pre-dates my own patch.

If I can't submit a bug-fix without being held up to checkpatch.pl , 
then those same requirements must be upheld by trivial, frivolous coding 
style "cleanups" as well.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Harvey, I know you mean well, and I thank you for that.  I hope you 
understand my point of view.

Regards,

Mike
