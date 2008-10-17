Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJQIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJQIkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYJQIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:40:07 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:56016 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYJQIkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:40:05 -0400
Date: Fri, 17 Oct 2008 10:39:37 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bodo Eggert <7eggert@gmx.de>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/5] SIGWINCH problem with terminal apps still alive
Message-ID: <20081017103937.3e7876c9@merlin.oi.pg.gda.pl>
In-Reply-To: <20081016134303.686adea2@merlin.oi.pg.gda.pl>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
	<20081012212244.117852e0@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131155280.5750@be1.lrz>
	<20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131359310.6408@be1.lrz>
	<20081014145104.24aa96d0@merlin.oi.pg.gda.pl>
	<20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
	<20081016122741.3b89f6f3@merlin.oi.pg.gda.pl>
	<20081016115202.090a74cd@lxorguk.ukuu.org.uk>
	<20081016134303.686adea2@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Welcome,

If we want to be more consistent with console behaviour the ptm/pty
behaviour should be similar. In my opinion it could be done
be using some kind of callback function which could be registered by
the program which rules ptm. Then it could be activated through
tty->ops->resize from tiocswinsz in tty_io. The default will be not set
so we get current typical behaviour.

We could also use some default function which calls tty_do_resize() if
called from master side and does nothing if called from slave side
so there is no change because real terminal sizes are not changed.
The terminal emulator program should register its callback
function which leads to proper resize and then signal generating by
ioctl(ptm,TIOCSWINSZ,). It is different from current behaviour but more
usable and sane IMHO.

The current ,,proper'' behaviour is inconsistent. For example you can
do "stty rows 0" on console and there is no change at all and no error
reporting too. With pty we get SIGWINCH signal and variable rows is
set to 0. Of course the real physical terminal is not changed at all.


Regards

-- 
Adam Tlałka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gdańsk University of Technology, Poland
