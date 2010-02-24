Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0BXVeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:34:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61856 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab0BXVeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x592jeMUvserdD/m3ojLbYRy4dJLZI7wypXBP4m8VnO/iYmtJfXNbC9Csw3QDlc9iu
         IpNT0X4CsQDqiCRwfZHzuZrdEomybaDr3ePuF8J6ONfyFGuB6RGb2DlmDQXy2pTtNnLv
         fIkt0QSNocNkoJXwyMp+ywbrfBA9ZYJUQWoSU=
Date: Wed, 24 Feb 2010 22:34:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Cc: mm-commits@vger.kernel.org, hidave.darkstar@gmail.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: + kernelh-printk-panic-string-cleanup.patch added to -mm tree
Message-ID: <20100224213406.GA7491@nowhere>
References: <201002242107.o1OL7F6v020376@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002242107.o1OL7F6v020376@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 01:07:15PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      kernel.h: printk/panic/string cleanup
> has been added to the -mm tree.  Its filename is
>      kernelh-printk-panic-string-cleanup.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/



Andrew, please don't merge this patch.

I'm not against the idea kernel.h gets split up a bit, by having
a prink.h and panic.h included from kernel.h for example.

But this patch breaks bisection: some tracing general helpers are
removed here but re-integrated in a different header only in a subsequent
patch in the series. This should be done in the same patch, otherwise it
breaks the build in the middle of the set.

The other problem, as Steve noticed, is that the tracing prototypes are
moved in ring_buffer.h (in the subsequent patch), which is not the right
place as the ring buffer is not only for tracing purpose. And also
it moves functions out of kernel.h while these are really useful for
general purposes.

That said, it's probably sane to think about a new header to put
these tracing prototypes, if it's included by kernel.h,
linux/ftrace.h is already filled with non-general purpose things.
So may be linux/trace.h ? Yeah this could be confusing, Steve what
do you think?

And all in one, it would probably better to split this in three
patches: one that moves printk helpers out of kernel.h to printk.h,
another following the same pattern for panic things and another one
for tracing things.

Thanks.

