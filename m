Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbYA2EuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbYA2EuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYA2EuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:50:05 -0500
Received: from [212.23.103.107] ([212.23.103.107]:65500 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755495AbYA2EuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:50:01 -0500
Date: Mon, 28 Jan 2008 06:43:43 +0100
From: Borislav Petkov <petkovbb@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/32] ide-tape redux v1
Message-ID: <20080128054343.GB3074@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de> <200801272045.40712.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801272045.40712.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

[...]

> > the BKL in idetape_write_release() with finer-grained locking etc, probably also
> > some pipeline improvements, removal of OnStream support, etc. but that'll come
> > later.
> 
> On-Stream support has been long gone but it seems that deprecation
> warning etc. managed to survive.
> 
> w.r.t. to the pipeline-mode: it should be pipelined into /dev/null
> 
> rationale:
> - it is _very_ complex
> - causes errors to be deferred till the next user-space access
> - direct I/O using blk_rq_map_user() will offer superior performance
> 
> the only question is whether to remove it...

Well, on the one hand, since the driver is only being maintained we should not
remove code that works. Also, i don't know how many users ide-tape really has
but, would it be worth the trouble at all? Because if nobody's using it, we
could just as well pipe the whole thing into /dev/null.. On the other hand, the
pipelining part _is_ kinda big and, right, it is not that straightfoward to
look at it and know what it actually does - it truly is a student project :)

> >  Documentation/ide/ChangeLog.ide-tape.1995-2002 |  405 +++
> >  drivers/ide/Kconfig                            |    3 +-
> >  drivers/ide/ide-tape.c                         | 4146 +++++++++---------------
> >  3 files changed, 1991 insertions(+), 2563 deletions(-)

[...]

> BTW what happend to patch #23?

Well, it appeared in my lkml mailbox having gone over vger which means at least
somebody got it :). But, yeah, that was a real nightmare yesterday sending all
those patches in one go. See, i got a stupid umts modem behind a not so transparent
proxy :) whose subnet is listed in almost every spam database on the planet
and whenever i try to send more than one mail i hit all sorts of mail server
restrictions like yahoo's maximum messages per day crap.. Gmail seems a bit
smarter ?! and scans the mail message and then says all kinds of funny stuff :):

27 10:48:31 gollum postfix/smtp[4011]: F1710123BFD: to=<linux-ide@vger.kernel.org>, relay=vger.kernel.org[209.132.176.167]:25,
delay=10, delays=0.19/0.29/2.7/7.2, dsn=2.7.1,	status=sent (250 2.7.1 Looks like Linux source DIFF email.. BF:<H 1.55041e-06>; S1753942AbYA0Js4)

what's next, probably something like:

...(250 3.x.x uh, ok, i'm gonna relay your mail but please have another coffee, please) <hash>;

Anyway, resending #23 to you in a private mail.

-- 
Regards/Gruﬂ,
    Boris.
