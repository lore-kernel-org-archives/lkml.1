Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYHDXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYHDXgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYHDXgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:36:46 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:53204 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYHDXgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:36:45 -0400
Message-ID: <4897928B.4090603@skyrush.com>
Date: Mon, 04 Aug 2008 17:36:43 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
References: <48977C96.2090005@skyrush.com> <20080805001129.72d06e60@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805001129.72d06e60@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If the output buffer is full then echoed characters/^C etc will vanish the
> way n_tty implements its buffering internally. It's always worked that
> way.

But since the flush is done just prior, shouldn't the buffer be empty
just before the ^C is written?  Or are you saying that the buffer could
refill in the meantime (between the flush and the ^C) if the chars are
comming in too fast?

What about the order of flush?...  Currently, it is:

	n_tty_flush_buffer(tty);		(ldisc buf)
	tty_driver_flush_buffer(tty);		(driver buf)

Would it be better to reverse this order, flushing the driver buffer
first so characters do not then refill the ldisc buffer before the
driver buffer can be flushed?

					-Thanks, Joe
