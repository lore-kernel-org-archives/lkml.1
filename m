Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYIYHIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYIYHIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYIYHH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:07:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:34294 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYIYHH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=As9RWdn0VdwvAw/deM1EqLPipCslF/TxuzWLcdzcoyiEo8ozTiYnL+MBj3u4WLhd7r
         bsgYESXbUNoqXPeVKbsyIzvFnWpAYXEq7ENtFhbbwegtTQPtk/D5WTSGsmtGsZbgof3l
         hG1Px4e4Q4DUxUxmiLTZD25KzRfMiWNKhwxGM=
Message-ID: <cabda6420809250007tb132ff8r8c6e5c7d821db664@mail.gmail.com>
Date: Thu, 25 Sep 2008 09:07:54 +0200
From: chri <chripell@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] [PATCH RESEND] max3100 driver
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-serial@vger.kernel.org
In-Reply-To: <200809242156.29505.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12219154581088-git-send-email-chripell@gmail.com>
	 <200809242156.29505.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 6:56 AM, David Brownell <david-b@pacbell.net> wrote:
>
> Small suggestion:  next time you resend this, make sure
> that $SUBJECT mentions it's a UART driver.  Maybe even that
> it's a SPI UART driver.  That should help get more comments.
>

OK!

>
> This is a bit picky, but it's the first thing I noticed when
> scanning the patch ... wierd comment layout!  Either indent
> those all, or (better) convert to kerneldoc style.

I will have a look at kerneldoc and do the change. I'm waiting for a
minor number in "Low-density serial ports" before resending the
modifications asked by Andrew and Alan, so I will do this too. I just
trusted M-q in emacs for the comment layout.

>
> Potentially less picky:  probe() doesn't lock max3100s[],
> neither does remove(), and in fact there seems to be no
> lock for that table.  Which suggests trouble in cases like

I (wrongly!) was assuming that probing of devices is serialized. I
will add the lock.

>
> And is that workqueue single threaded?
>

it's freezeabe and (looking at include/linux/workqueue.) it implies
that it's single-threaded. This is important because I don't do
locking since I presume all the I/O to the MAX3100 is done in just one
workqueue. When I do I/O in other places (suspend for example) I
assume that the worqueue is friezed so not running.

Best regards and thanks for the review,

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
