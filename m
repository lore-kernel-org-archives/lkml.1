Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYIPUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYIPUVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYIPUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:21:10 -0400
Received: from 1wt.eu ([62.212.114.60]:4137 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYIPUVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:21:09 -0400
Date: Tue, 16 Sep 2008 22:21:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: karthikeyan S <karthispeaks@gmail.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: A bug (probably) in stop_all_threads
Message-ID: <20080916202102.GA5509@1wt.eu>
References: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com> <o44nc4dd8tpl94vf9bv81oklq8lt29112t@4ax.com> <20080916051751.GA28475@1wt.eu> <3bedf6ab0809152249r524cce0v1c14bfdff46aa12d@mail.gmail.com> <20080916062226.GA29225@1wt.eu> <3bedf6ab0809160128l101d44feh671dbeb4a8401360@mail.gmail.com> <20080916092830.GB30026@1wt.eu> <3bedf6ab0809161230u1cc346f5xb05957309426505f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bedf6ab0809161230u1cc346f5xb05957309426505f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 01:00:19AM +0530, karthikeyan S wrote:
> On Tue, Sep 16, 2008 at 2:58 PM, Willy Tarreau <w@1wt.eu> wrote:
> > On Tue, Sep 16, 2008 at 01:58:21PM +0530, karthikeyan S wrote:
> >> On Tue, Sep 16, 2008 at 11:52 AM, Willy Tarreau <w@1wt.eu> wrote:
> >> > On Tue, Sep 16, 2008 at 11:19:58AM +0530, karthikeyan S wrote:
> >> >> Hi Willy,
> >> >>
> >> >> Thanks for getting back. Yes, I tried to set the state to
> >> >> TASK_INTERRUPTIBLE. It solves the issue. The other processes now get a
> >> >> chance to handle the SIGSTOP sent to them.
> >> >
> >> > OK, that will help me review the current code and compare it with 2.6.
> >> > If you could send me your patch, it will even save me more time. Based
> >> > on your report, it's very likely that it will get merged.
> >>
> >> Sure, I can definitely send the patch. I haven't sent a patch before,
> >> and I am not fully aware of the process to follow. It might take a
> >> little bit if time, but I will try to send it very soon.
> >
> > in order not to waste your time, here is how to proceed :
> >
> > go to the directory where both your new kernel and old kernel are.
> > Here is how you do then :
> >
> >  $ diff -urN linux-2.4.36-bad linux-2.4.36-goot  > my-patch.diff
> >
> > (ensure that you don't have lots of old or temporary files in it).
> > You might have to run a "make distclean" in each dir first.
> >
> > Then integrate the result as inline text into your mail, and as an added
> > bonus, other people will be able to comment on your work.
> 
> Willy, Thank you for the info.
> 
> I downloaded a 2.4.36 version from kernel.org, there is no
> stop_all_threads() at all in that version.
> do_coredump() mechanism seems to have been changed. It does not call
> stop_all_threads().
> 
> I am not sure which 2.4 version we are using for our device that have
> stop_all_threads().

OK, that does not matter for mainline then.

> And also I am not sure from where our guys had picked up the "dump
> core for all threads" patch which includes the stop_all_threads
> function. Had this function been there ever in official 2.4? Thanks a
> lot.

No, I don't think so. But you should check Redhat and SuSE kernels,
they were heavily patched to support an early version of the 2.6 O(1)
scheduler, NPTL threads and things like this. As a result, there were
a large number of changes in this area and your patches might come
from there. Also check for Andrea Arcangelli's patches (2.4-aa), they
were approximately the ones that constituted the SuSE kernels by that
time. I'm pretty sure that you'll find what you're looking for from
at least one of these 3 sources.

> So, looks like the need to send the patch is not there anymore? :-(

No, but that does not matter. I prefer one false alarm once in while
than no alarm with a big open hole ;-)

Good luck,
Willy

