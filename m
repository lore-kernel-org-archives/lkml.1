Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZBHWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZBHWG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZBHWGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:06:37 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34887 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091AbZBHWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:06:36 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 14:06:34 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and 
 CLOCK_MONOTONIC?
In-Reply-To: <cfd18e0f0902081353t70f9e107g28f8003f356f84db@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902081405120.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>  <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>  <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>  <cfd18e0f0902081329j4b18c4f2g91269d3209f1932d@mail.gmail.com>
  <alpine.DEB.1.10.0902081340320.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081353t70f9e107g28f8003f356f84db@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Michael Kerrisk wrote:

> On Mon, Feb 9, 2009 at 10:50 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> >
> >> > @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
> >> >        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
> >> >        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
> >> >
> >> > -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
> >> > +       if ((flags & ~TFD_FLAGS_SET) ||
> >> > +           invalid_clockid(clockid))
> >> >                return -EINVAL;
> >>
> >> Oh!  Does this mean that in 2.6.2[789] it wasn't possible to use
> >> TFD_TIMER_ABSTIME?
> >
> > No, sorry, my fault. Patch is wrong. In "create" ATM we accept only
> > FCNTL-like flags. In "settime" we get TFD_TIMER_ABSTIME (that needs a
> > check too for EINVAL).
> 
> That last piece should be a separate patch, that also gets pushed back
> into -stable.  Do you agree?

Hmm, it's a check for extra bits that do not cause any harm. Dunno if it 
fits -stable requirements. You should ask Greg.



- Davide


