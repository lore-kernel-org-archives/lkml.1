Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJFNOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJFNOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYJFNN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:13:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752434AbYJFNN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:13:59 -0400
Date: Mon, 6 Oct 2008 14:13:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/0] SIGWINCH problem with terminal apps
Message-ID: <20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So as a quick solution I made patches which move mentioned updates
> before kill_pgrp() calls. As I tested modified kernel there is no
> observed effect now. So I send patchs.

NAK - this might happen to make the race miss on your box but it's not a
fix of any kind.

> There are some places where kill_pgrp() call is used and some variable
> is changed after it. It should be considered if this code is always
> working properly or some race scheduler condition exists.

The code was never race free, the scheduler change made the problem show
up more. Later 2.6.27-rc has patches that use the termios lock across
TIOCG/SWINSZ and deal with the problem properly.

Alan
