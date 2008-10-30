Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYJ3NZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYJ3NZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYJ3NYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:24:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:40615 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYJ3NYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GXsK0Ry7c6hXQVD7TdPqGu659q+qUf2zfsjXYx56AFB0deWETzedrHD0V9vFMMc/2w
         J3SmkVCGGAFZZ3clVAaWMDvABkZY9zenqmZvXIb0fzUF18IhoTwySGviN0blrnfWeBUt
         RlkOQaHqy3wsiPx4FTHfMT0NvzmN41XKh4QiI=
Message-ID: <cfd18e0f0810300624g7948b2efqe979278413d746b8@mail.gmail.com>
Date: Thu, 30 Oct 2008 08:24:44 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: Valdis.Kletnieks@vt.edu
Subject: Re: parent process behaviour to signal after vfork()
Cc: "Halesh S" <halesh.s@india.com>, linux-kernel@vger.kernel.org
In-Reply-To: <53383.1225345110@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20081028T062822-852@post.gmane.org>
	 <517f3f820810290617m49b5deccu5d639cd0d3c94592@mail.gmail.com>
	 <53383.1225345110@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

On Thu, Oct 30, 2008 at 12:38 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 29 Oct 2008 08:17:36 CDT, Michael Kerrisk said:
>
>> diff --git a/man2/vfork.2 b/man2/vfork.2
>> index 55044ad..8a7ed50 100644
>> --- a/man2/vfork.2
>> +++ b/man2/vfork.2
>> @@ -94,7 +94,10 @@ but may call
>>  .PP
>>  Signal handlers are inherited, but not shared.
>>  Signals to the parent
>> -arrive after the child releases the parent's memory.
>> +arrive after the child releases the parent's memory (i.e., after the child calls
>> +.BR _exit (2)
>> +or
>> +.BR execve (2)).
>
> OK, I'll bite - when is the parent's memory released if the child doesn't
> depart by calling _exit() or execve(), but manages to get killed by an
> unhandled signal or the OOM killer or similar?

Yes, thanks for catching that.  The wording really should say, until
the child does execve(2) or it terminates.

> (That's the generic problem with adding itemized lists to an explanation - it's
> rarely clear if the list is an exhaustive list, or a non-complete list of
> examples.  Note how often we have flame wars regarding which EQUUX should be
> returned in a corner case that hinge on whether Posix says "Only FOO, BAR,
> and BAZ can be returned" or "FOO, BAR, BAZ are among the errors that can be
> returned")

I agree that this is sometime true, but examples need to be looked at
on a case-by-case basis.  Sometimes using deliberately vague language
is appropriate.  But sometimes, the solution is just better, more
precise language, and I think that's the case here.  For
man-pages-3.13, I applied the patch below.

Cheers,

Michael
