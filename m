Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZG1Kmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZG1Kmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZG1Kmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:42:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43328 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZG1Kmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:42:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
Date: Tue, 28 Jul 2009 19:42:28 +0900
In-Reply-To: <20090728112203.7b70adba@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Tue, 28 Jul 2009 11:22:03 +0100")
Message-ID: <87prblt7fv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Just a quick hack though. Is this wrong/unpreferable way?
>> 
>> n_tty_read() checks the pending buffer and consume it before
>> input_available_p().
>
> That won't change the fact that the process could have exited.

Yes.

> You can fix the -ENXIO reporting that way (and it is basically what
> the EOFPENDING/EOF patch did), but the only way I can see to fix the
> assumption that the process exit means all the data is in the ldisc
> the other end ready to use is to actually to make the close() path
> block - but with some kind of limits to prevent deadlocks.

I thought, to check in n_tty_read() may guarantee that tty->buf (slave
guarantee to sent to tty->buf) is consumed by master side.

I hoped this tty->buf works as the pending data in ldisc.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
