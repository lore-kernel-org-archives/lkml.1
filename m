Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYIINMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYIINMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYIINMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:12:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49562 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751176AbYIINMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:12:33 -0400
Date: Tue, 9 Sep 2008 14:12:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-ID: <20080909141210.4fd546a1@lxorguk.ukuu.org.uk>
In-Reply-To: <48C67374.1000108@skyrush.com>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
	<20080908173250.2452c5b8.akpm@linux-foundation.org>
	<48C67374.1000108@skyrush.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think this is a good idea either, since I don't want to spinlock
> during the output processing, which calls the driver output func.  I
> think a mutex is more appropriate anyway (and there are some already
> defined and in use for tty write locking, etc.) - let me know if you
> think otherwise.  I will play around with this and re-post a patch for
> review soon.

The driver output side can sleep, and it has to be able to sleep because
the drivers like USB need to be able to sleep.

If you have the column handling isolated and locked that is a big step
towards exterminating the BKL in the n_tty code. It also illustrates why
locking people always say "lock data not code".

Alan
