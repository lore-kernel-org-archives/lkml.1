Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZBHWRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZBHWRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZBHWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:17:24 -0500
Received: from kroah.org ([198.145.64.141]:51190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754411AbZBHWRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:17:23 -0500
Date: Sun, 8 Feb 2009 14:10:27 -0800
From: Greg KH <greg@kroah.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] Why does timerfd() only support CLOCK_REALTIME and
	CLOCK_MONOTONIC?
Message-ID: <20090208221027.GA14523@kroah.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com> <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081329j4b18c4f2g91269d3209f1932d@mail.gmail.com> <alpine.DEB.1.10.0902081340320.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081353t70f9e107g28f8003f356f84db@mail.gmail.com> <alpine.DEB.1.10.0902081405120.18839@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902081405120.18839@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 02:06:34PM -0800, Davide Libenzi wrote:
> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> 
> > On Mon, Feb 9, 2009 at 10:50 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > > On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> > >
> > >> > @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
> > >> >        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
> > >> >        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
> > >> >
> > >> > -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
> > >> > +       if ((flags & ~TFD_FLAGS_SET) ||
> > >> > +           invalid_clockid(clockid))
> > >> >                return -EINVAL;
> > >>
> > >> Oh!  Does this mean that in 2.6.2[789] it wasn't possible to use
> > >> TFD_TIMER_ABSTIME?
> > >
> > > No, sorry, my fault. Patch is wrong. In "create" ATM we accept only
> > > FCNTL-like flags. In "settime" we get TFD_TIMER_ABSTIME (that needs a
> > > check too for EINVAL).
> > 
> > That last piece should be a separate patch, that also gets pushed back
> > into -stable.  Do you agree?
> 
> Hmm, it's a check for extra bits that do not cause any harm. Dunno if it 
> fits -stable requirements. You should ask Greg.

If it fixes a bug, it would go into -stable.  Does this?

thanks,

greg k-h
