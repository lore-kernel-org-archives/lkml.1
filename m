Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYDISad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYDISad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYDISaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:30:14 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:41814 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbYDISaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L+yomB2n6cMZmhgkG+AUQtoiRNe4CR7T4TARY1g3F/9QIT83EydHRsOKbOoiHynH6/uvIaqWuFzue8oRp4v8BsIiI1N/jl5oel1ZHL8STB3f9fC2QjRNZ2cH4Cy5dMEEASmO5TbQnkexpKk+cjCw08NRpz5eQ+uSfvT55CMYCf4=
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT
	ION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, abraham.manu@gmail.com,
       mchehab@infradead.org
In-Reply-To: <37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
References: <1204613661.22933.110.camel@brick>
	 <47F536FF.8060105@linuxtv.org>
	 <37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com>
	 <37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 11:30:25 -0700
Message-Id: <1207765825.16220.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 13:00 -0400, Michael Krufky wrote:
> On Fri, Apr 4, 2008 at 11:09 AM, Michael Krufky <mkrufky@linuxtv.org> 
> Harvey,
> 
> I have received your entire patchset.  Some patches have already been
> merged into our development tree, others have been dropped, since some
> of individual driver maintainers have decided to remove the
> __FUNCTION__ macro from their source code altogether, rather than
> accept this change.
> 
> I have merged the remaining pending patches into a mercurial tree,
> hosted on linuxtv.org:
> 
> http://linuxtv.org/hg/~mkrufky/function-func
> 
> Please note that I had to manually apply patches 8, 11 and 13, since
> you generated your changes against the git repository rather than the
> official v4l-dvb development repository hosted on linuxtv.org.

I don't know/use mercurial, sorry, I thought git-v4l's devel branch on
kernel.org would be a mirror of the development tree...guess I was
mistaken

> 
> I must stress this -- all v4l-dvb patches, ESPECIALLY
> codingstyle-cleanups (due to the nature of those patches, touching
> many many files at once), should always be generated against the
> v4l-dvb master development repository hosted on linuxtv.org.
> 
> Now, I have a question.....
> 
> About this change from __FUNCTION__ to __func__ , I understand that
> this change is being done kernel-wide.  At first, I had blindly
> accepted this change as a kernel-janitor "cleanup", until it was
> pointed out to me last night, that older compilers do not support
> __func__.  Sure, one can always do the following for compat:
> 
> #ifndef __func__
>  #define __func__ __FUNCTION__
> #endif /* __func__ */

This is already done in kernel.h, so __func__ is already being passed to
any compiler used on the kernel....

/* Trap pasters of __FUNCTION__ at compile-time */
#define __FUNCTION__ (__func__)

> 
> ...but the question is raised, why are we making this change in the first place?
> 
> Don't get me wrong -- as I said before, I understand that this change
> is kernel-wide, and I am not arguing against it.  I will continue on
> to have this merged into 2.6.26.  I would just like to see a link that
> points to a discussion thread on LKML that explains the reasons for
> this change, and where this change was globally agreed to.  Again -- I
> am not challenging these patches.  I merely want to read more
> information as to why we are making this move.
> 
> In the meanwhile, below is the checkpatch.pl fallout after applying
> your __FUNCTION__ to __func__ series.  Since you are working on these
> codingstyle cleanups anyway, I'd imagine that you won't mind fixing
> these checkpatch.pl "errors" and "warnings" before we merge these
> changes.

For such a large set in v4l, it's a drastic increase in work to do so
in this case as it is a simple sed s/__FUNCTION__/__func__/

> 
> I understand if you don't want to alter code that you may not be
> directly involved in, but I am sure you will have no trouble at least
> fixing the "comma after space" and "line over 80 characters" cases.
> 
> Please generate the additional cleanups against the mercurial tree
> that I merged your previous series to:
> 
> http://linuxtv.org/hg/~mkrufky/function-func

Do you have a git mirror somewhere?

> 
> Also, please generate the codingstyle cleanup patches individually
> based on the directory structure, just as you did in your last series.
> 
> See below for the checkpatch.pl "errors" and "warnings".

I can't say I have much enthusiasm for that, but if you'd really want
such a patch, I will try to get to it this week.


Harvey

