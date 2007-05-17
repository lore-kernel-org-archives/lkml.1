Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbXEQXvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbXEQXvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXEQXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:50:52 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:3268 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXEQXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cGIA3nsATUt8vmy2YKY1VGHwl57/CUqhENyXKyHvNv06jNaY9Kad9Kwa6n/PnKRkjZteEWnnd0awihuNdOrJ/fqT6pjfXxr5S3px0EpGeiNvy8uoWdUuPvXXZ7T8hfqLkUMv+e7aCrciGWWSTS8bXKMVvXeLpDIEaHbu+IboUdI=
Message-ID: <a2ebde260705171650v6a8de642rde6e5c61261d9d5e@mail.gmail.com>
Date: Fri, 18 May 2007 07:50:50 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "pradeep singh" <2500.pradeep@gmail.com>,
       "Bahadir Balban" <bahadir.balban@gmail.com>,
       "Learning Linux" <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <464C7DA5.7070008@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
	 <a2ebde260705161617u260bcb55i8c4a56e4a4875954@mail.gmail.com>
	 <464C7DA5.7070008@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Phillip,

I have said the gap between you and me is the definition of context.
In Robert's definition, *context* is used in a classification method
and really something in higher-level. And I used that term to explain
why ISR can not sleep.

If you do not like the name, name it your way and substitute term
*context* in my previous mail with what you name. But I believe my
other explaination still hold, right?

And again, if anyway I am forced to use your termnology system, I
would also agree your other point regarding hardware.


2007/5/18, Phillip Susi <psusi@cfl.rr.com>:
> Dong Feng wrote:
> > OK. I think the gap between you and me is the definition of term
> > *context*. If you go to Linux Kernel Development, 2nd Edition (ISBN
> > 0-672-32720-1), Page 6, then you will read the following:
> >
> > ....  in Linux, ... each processor is doing one of three things at any
> > given moment:
> >
> > 1. In kernel-space, in process context, ...
> > 2. In kernel-space, in interrupt context, not associated with a process,
> > ...
> > 3. In user-space ...
> >
> > This list is inclusive. ...
>
> Yep, I disagree with that use of the term, because it is misleading and
> caused your confusion.  The context that the ISR executes in is not
> associated with a _known_ process is more correct.
>
> > Maybe you prefer other terminology system, but I do like the above
> > definition given by Robert Love. So maybe in your system *context*
> > mean something at hardware level and you say ISR is in process
> > context, but I think it is more like a logical level and agree with
> > Rovert's definition.
> >
> > And in hardware level, Robert's *context* definition also mean
> > something specific, that I started to be aware of. That is, *in the
> > same context* means a kernel-code is triggered by a user-space code.
> > *in different context* means a kernel-code is triggered by an external
> > interrupt source other than a user-space code.
>
> Right, and that becomes more clear when you say that the ISR's is
> executing in an indeterminate process context, rather than saying it
> does not have any context at all, or has its own special context.
>
> > Context has nothing to do with whether an ISR borrow any data
> > structure of a process, instead, its something logical or related to
> > causality.
>
> No, it has everything to do with the data structures of the process.
> When you are executing "in the same context" as you put it, as called
> from the user mode code, you know you are using the task structure of
> that process and so you can make use of that structure.  For example,
> you can look at the current uid to decide if you should allow an
> operation to proceed.  When you are in an ISR, there _is_ a task
> structure there, but you shouldn't use it because you don't know which
> task structure it is because you don't know which task you are
> interrupting.  Thus if you look at the current uid in an ISR, you have
> no idea what you will see there and it will change from interrupt to
> interrupt, depending on which task gets interrupted.
>
>
>
