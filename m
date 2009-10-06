Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbZJFML4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbZJFML4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZJFML4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:11:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42593 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932230AbZJFMLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:11:55 -0400
Date: Tue, 6 Oct 2009 13:12:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: felipe.balbi@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006131230.5301f711@lxorguk.ukuu.org.uk>
In-Reply-To: <20091006114528.GV4452@nokia.com>
References: <20091006094845.GT4452@nokia.com>
	<20091006114528.GV4452@nokia.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> why doesn't receive_buf() return the amount of bytes actually received ?

You'd have to ask whoever wrote the code in 199something.

> I see flush_to_ldisc() believes it can flush everything before even
> calling receive_buf() then it will never act on the possibility of
> receive_buf() not being able to receive the entire data.

The ldisc is responsible for maintaining tty->receive_room correctly at
all times.

> Am I right ? Should receive_buf() return the amount of bytes actually
> received ? Also, why isn't receive_room enough to be sure there's
> enough space to really receive that block of data ?

I've not seen this reported elsewhere so I assume you are somehow
tripping a bug in the n_tty ldisc code. The other possibility is that you
are in canonical mode and some of your input is intentionally discarded
by the ldisc either as errors, overruns or through things like quoting or
flow control.
