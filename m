Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZJGQeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZJGQeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbZJGQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:34:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46756 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZJGQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hKyGBEsl+Jdi2ZLbJ8UtmhH5jUQ2YAfPQzvJHe7M9mMihZeJTlDB4ooo9cfgUfodji
         AyKjCBQ5Voj/DJ5EOaozA3a/l1xZ1Ot0UO54btQqeV3WcE514UcvtbbF1wffbesQqOnD
         wQAyQk8HAv26mhjMmW1LT9S7wit+oFLXWS3Nw=
Date: Wed, 7 Oct 2009 09:33:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       linux-input@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091007163327.GA12053@core.coreip.homeip.net>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net> <20091006075816.GA1362@ucw.cz> <20091007043603.GC10204@core.coreip.homeip.net> <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 10:42:08PM +0800, Eric Miao wrote:
> On Wed, Oct 7, 2009 at 12:36 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tue, Oct 06, 2009 at 09:58:17AM +0200, Pavel Machek wrote:
> >> Hi!
> >>
> >> On Mon 2009-10-05 22:06:50, Dmitry Torokhov wrote:
> >> > On Wed, Sep 30, 2009 at 10:07:46PM +0200, Pavel Machek wrote:
> >> > >
> >> > > It complains about unbalanced irq 113 wake disable. That one belongs
> >> > > to matrix-keypad...
> >> >
> >> > I guess some of enable_irq_wake()s fail on your box. Do you see it if
> >> > you apply the patch below?
> >>
> >> I'll do short test. But... if you are right, your patch will just make
> >> your machine refuse to suspend... right?
> >>
> >> Ungood.
> >
> > It was just a debug patch.
> >
> >>
> >> Actually, it seems to break suspend (returns  -EINVAL while refusing
> >> to suspend), warnings are still there, and keyboard is dead after
> >> failed suspend... double plus ungood.
> >>
> >> Aha, so warning is solved: the one in the log is from gpio_buttons.
> >>
> >
> > OK, so it looks like your box refuses to set up one of the GPIOs as a
> > wakeup source... Hmm, either your box is wrong ;) or matrix_keypad
> > driver needs to maintain a separate list of wakeup GPIOs.
> >
> 
> This is due to the nature of PXA processor, where not every GPIO can
> be configured as a wakeup source. Mmm.... we can either return a
> pseudo value indicating setting wakeup on that GPIO is OK (which
> doesn't sound like a good idea), or we can just ignore the failure of
> enable_irq_wake() in matrix_keypad?

We ignore the failure right now in the mainline but that causes stack
traces on resume as we trying to disable not enabled wakeup GPIOs. That
was original Pavel's complaint.

-- 
Dmitry
