Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXLBLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXLBLfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXLBLf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:35:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34397 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbXLBLf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:35:26 -0500
Date: Sun, 2 Dec 2007 12:36:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071202113609.GA1796@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <200711291010.12707.david-b@pacbell.net> <20071130203544.GB1677@elf.ucw.cz> <200711301310.40360.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711301310.40360.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It's not an issue of accidental writes, it's an issue of there being
> > > no other synchronization for setting those alarms.  Remember that both
> > > RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
> > > could a different userspace activity ...
> > 
> > We have 3 interfaces to one hardware resource. I do not think kernel
> > should try to arbitrate it here. There's just one alarm clock with
> > three interfaces.
> 
> Having three interfaces is bad enough ... ensuring that none of
> them can ever be used safely would be stupid.

They can be used safely. You just have to pick one and stay with
it. (And no, no-clobber hack does not help here. Or do you have
specific application where no-clobber hack helps?)

Anyway, with wildcarded dates, no-clobber is a problem -- because you
need to kill the alarm after you waken up, or it will repeat.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
