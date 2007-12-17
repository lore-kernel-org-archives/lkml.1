Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXLQN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXLQN1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbXLQN11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:27:27 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:37246 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215AbXLQN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:27:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DSyI/9Ocfd1pYDZCTAlaAeR/b3L6kygQ08FjZtK0evIZxVwIlNnV7kOM8omda3TyX867m8A5FdAKrcyGAMRZ1VJfyovK4dhoViCjeR9zWow3pfV50aedIjdTw375/6y0nqCyjiIFmLyNr1PVAM+ypBX5Slimg3OtArAwtJNT41Q=
Message-ID: <cfd18e0f0712170527k6e2f20ddq8d3abc367aa20661@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:27:23 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: Tesing of / bugs in new timerfd API
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Greg KH" <gregkh@suse.de>,
       "Christoph Hellwig" <hch@lst.de>,
       "Linux Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712161210120.14339@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47614369.3060906@gmail.com>
	 <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
	 <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com>
	 <Pine.LNX.4.64.0712131603010.10881@alien.or.mcafeemobile.com>
	 <4762683D.8050007@gmail.com>
	 <Pine.LNX.4.64.0712161210120.14339@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On 12/16/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Fri, 14 Dec 2007, Michael Kerrisk wrote:
>
> > You snipped my example that demonstrated the problem.  Both of the
> > following runs create a timer that expires 10 seconds from "now", but
> > observe the difference in the value returned by timerfd_gettime():
> >
> > $ ./timerfd_test 10         # does not use TFD_TIMER_ABSTIME
> > Initial setting for settime:   value=10.000, interval=0.000
> > ./timerfd_test> g
> > (elapsed time=  1)
> > Current value:                 value=346.448, interval=0.000
> >
> > $ ./timerfd_test -a 10      # uses TFD_TIMER_ABSTIME
> > Initial setting for settime:   value=1197630855.254, interval=0.000
> > ./timerfd_test> g
> > (elapsed time=  1)
> > Current value:                 value=1197630855.254, interval=0.000
> >
> > Either there's an inconsistency here depending on the use of
> > TFD_TIMER_ABSTIME, or there is a bug in my understanding or my test
> program
> > (but so far I haven't spotted that bug ;-).).
>
> Can you try the two patches below? I tried them on my 32 bit box (one of
> the rare beasts still lingering around here) and it seems to be working
> fine (those go on top of the previous ones).

Against 2.6.24-rc5, I applied first your earlier patches ("v3") and
then the newest patch.  My tests confirm that:

> This fixed the 32 bit tick-count truncation, and makes the time returned
> to be the remaining time till the next expiration.

Are you going to resubmit a new patch set that includes these latest changes?

Michael
