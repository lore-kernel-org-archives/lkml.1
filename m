Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYJVJAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYJVJAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYJVJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:00:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058AbYJVJAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:00:43 -0400
Date: Wed, 22 Oct 2008 10:00:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 72/80] tty: fix up gigaset a bit
Message-ID: <20081022100045.2f06e977@lxorguk.ukuu.org.uk>
In-Reply-To: <48FB27F1.9010007@imap.cc>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
	<20081013094438.21645.30934.stgit@localhost.localdomain>
	<48F762CA.4080608@imap.cc>
	<20081017124004.64d3f2cf@lxorguk.ukuu.org.uk>
	<48FB27F1.9010007@imap.cc>
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

> additional test_bit(TTY_IO_ERROR, &tty->flags) would catch a case that
> would otherwise be handled incorrectly?

Fiddling with tty->disc_data by hand probably currently does the right
thing. I don't guarantee it will continue to do so after the BKL removal
gets to ldisc setting.

> So I think removing the poll method is the right thing to do. If you
> have no objections, I'll submit a patch doing just that. (Hoping to
> still make it for the .28 merge window.)

If you really don't need the poll then it can go - for 2.6.29. The
current code isn't wrong on a functional level it just returns unexpected
results in the unplug case.
