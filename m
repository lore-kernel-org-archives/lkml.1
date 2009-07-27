Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZG0MHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZG0MHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZG0MHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:07:35 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42891 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZG0MHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:07:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
Date: Mon, 27 Jul 2009 21:07:28 +0900
In-Reply-To: <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 27 Jul 2009 11:57:23 +0100")
Message-ID: <873a8iqqgv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> I see. It sounds like good thing. The attached patch or something?
>> Anyway, I'm not familiar with the tty stuff obviously, so, I'm not sure
>> whether this patch is right or not.
>
> It turns out to be a little bit trickier than I thought because of open
> v close v flush_to_ldisc races (some of the open/close ones being long
> standing).
>
> We now use tty->buf.lock to keep EOF/EOFPENDING/OTHER_CLOSED all in order
> together. That has no real cost as we already hold the buf.lock in the hot
> path which is flush_to_ldisc.
>
> Anyway this is my current thoughts (not yet given a testing)

I see. Looks like clean to me.

> +	spin_lock_irqsave(&pair->buf.lock, flags);
> +	pair->packet = 0;

I worried "pair->packet = 0" when I'm thinking this. I guess it would be
changed more early than before. Is it ok?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
