Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZADVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZADVQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZADVQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:16:00 -0500
Received: from vuizook.err.no ([85.19.221.46]:39538 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZADVQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:16:00 -0500
From: Tollef Fog Heen <tfheen@err.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: Re: [PATCH] Winchiphead 340/1: full baud rate and status/control line support
References: <87iqovs740.fsf@qurzaw.linpro.no>
	<20090104121652.35a33c4c@lxorguk.ukuu.org.uk>
Mail-Copies-To: never
Date: Sun, 04 Jan 2009 22:15:51 +0100
In-Reply-To: <20090104121652.35a33c4c@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sun, 4 Jan 2009 12:16:52 +0000")
Message-ID: <87zli693i0.fsf@qurzaw.linpro.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

]] Alan Cox 

| > +	if (factor > 0xfff0) { /* Clamp */
| > +		factor = 0xfff0;
| > +		divisor = 0;
| > +	}
| > +
| > +	t1 = factor;
| > +	for (t2 = divisor; t2 <= CH341_BAUDBASE_DIVMAX; t2++)
| > +		t1 >>= 3;
| > +	baud = CH341_BAUDBASE_FACTOR / t1;
| > +
| 
| Same question as before: Can baud really become zero at this point ? Also
| for that matter what guarantees that t1 cannot become zero in this
| computation ?

Nothing, that code is completely wrong.  I've rewritten it now.  Thanks
for explaining.

| > +	if (baud && tty)
| > +		tty_encode_baud_rate(tty, baud, baud);
| 
| The check for B0 (hangup) was done earlier (see set_termios). So if you
| can end up with a requested baud rate being turned into 0 you need to
| bump it up to 1. If not you don't need the test.

Indeed, fixed as well.  New patch incoming in a few minutes.

I've also added the mutex protecting set_handshake, but I feel less
confident about whether that's the right approach, so feedback there is
also appreciated.

-- 
Tollef Fog Heen
UNIX is user friendly, it's just picky about who its friends are

