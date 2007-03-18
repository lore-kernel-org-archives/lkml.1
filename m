Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXCRHWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXCRHWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 03:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXCRHWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 03:22:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:17282 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXCRHWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 03:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mPqHbFOD2rGd7ejqb1/6L5/bM+0subq3mcKgAZL8b8oGSFYWYI3ipEjEGGE85SrAnOClqL5f1Tp0X6Mu8xLq/PwKcRRwgvi3uHGkgWS4JWY5EBNg5QTlDtAeDQcxG4CddiwcfyD2GvLZF4SKOLoaoqhPBrLUdwTjEljmIi3JMr4=
Message-ID: <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
Date: Sun, 18 Mar 2007 08:22:02 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: RSDL v0.31
Cc: "Kasper Sandberg" <lkml@metanurb.dk>, "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174201726.8732.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2007-03-18 at 07:47 +0100, Kasper Sandberg wrote:
>
> > > So neither does a good job with this load.
> > that sorely depends on what you mean by good job.
> >
> > It seems like what you call a good job is preserving the speed of the
> > gui(X + apps which uses it) at _ALL_ costs to other stuff.
>
> Wrong.  I call a good job giving a _preference_ to the desktop.  I call
> rigid fairness impractical for the desktop, and a denial of reality.

My sound programs (audacity, non-RT) and mplayer disaggree with you. :-)
Not to mention some more mundane stuff like Gajim. (no stall with its
slow PyGTK UI on RSDL)

(Hint: I'm using Xfce, not KDE)

I'd recon KDE regresses because of kioslaves waiting on a pipe
(communication with the app they're doing IO for) and then expiring.
That's why splitting IO from an app isn't exactly smart. It should at
least be ran in an another thread.

A much better approach would be running IO in the context of the app,
but using a common shared library.

Also, Beryl works better with RSDL too.
(blur doesn't "disable" itself sometimes - which is the result of a lag)
