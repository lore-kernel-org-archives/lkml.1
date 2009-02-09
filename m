Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZBICdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZBICdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZBICcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:32:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:33129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZBICcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:32:51 -0500
Date: Sun, 8 Feb 2009 18:24:28 -0800
From: Greg KH <gregkh@suse.de>
To: mtk.manpages@gmail.com
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and
	CLOCK_MONOTONIC?
Message-ID: <20090209022428.GA10891@suse.de>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com> <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081329j4b18c4f2g91269d3209f1932d@mail.gmail.com> <alpine.DEB.1.10.0902081340320.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081353t70f9e107g28f8003f356f84db@mail.gmail.com> <alpine.DEB.1.10.0902081405120.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081412x67f97e9eq7df94148807107c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0902081412x67f97e9eq7df94148807107c8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 11:12:21AM +1300, Michael Kerrisk wrote:
> On Mon, Feb 9, 2009 at 11:06 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> >
> >> On Mon, Feb 9, 2009 at 10:50 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> >> > On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> >> >
> >> >> > @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
> >> >> >        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
> >> >> >        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
> >> >> >
> >> >> > -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
> >> >> > +       if ((flags & ~TFD_FLAGS_SET) ||
> >> >> > +           invalid_clockid(clockid))
> >> >> >                return -EINVAL;
> >> >>
> >> >> Oh!  Does this mean that in 2.6.2[789] it wasn't possible to use
> >> >> TFD_TIMER_ABSTIME?
> >> >
> >> > No, sorry, my fault. Patch is wrong. In "create" ATM we accept only
> >> > FCNTL-like flags. In "settime" we get TFD_TIMER_ABSTIME (that needs a
> >> > check too for EINVAL).
> >>
> >> That last piece should be a separate patch, that also gets pushed back
> >> into -stable.  Do you agree?
> >
> > Hmm, it's a check for extra bits that do not cause any harm. Dunno if it
> > fits -stable requirements. You should ask Greg.
> 
> I agree that it's not a critical fix.  The point is of course that if
> other flags are evntually added to timerfd_settime(), an application
> needs a way of checking for kernel support / lack of support (a la the
> recent discussion of eventfd "[patch/rfc] eventfd semaphore-like
> behavior").  It seems to me it would be good to have that check work
> as far back as possible in older kernels. If that check is to be added
> to 2.6.29, it seems reasonable to push it back to the current -stable
> kernels.
> 
> Greg?

Sounds reasonable to me.

thanks,

greg k-h
