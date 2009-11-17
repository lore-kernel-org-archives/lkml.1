Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZKQRhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZKQRhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZKQRhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:37:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZKQRhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:37:09 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Yow: I want DUSTIN HOFFMAN!! .. I want LIBERACE!!  YOW!!
Date: Tue, 17 Nov 2009 18:36:41 +0100
In-Reply-To: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de>
	("Uwe =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Tue, 17 Nov 2009
 17:51:40 +0100")
Message-ID: <m3lji5xdcm.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> strcmp("\x01", "\xef") returns 18 but it should return something < 0.
> The reason is that the variable holding the result of the subtraction is
> too small and overflows.

When char is signed strcmp("\xef", "\x01") still returns something < 0.
You need to cast to unsigned char first.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
