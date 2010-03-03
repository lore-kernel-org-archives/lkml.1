Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CCLrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:47:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50531 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751709Ab0CCLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:47:30 -0500
Date: Wed, 3 Mar 2010 11:50:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Hayward <hayward@loup.net>
Cc: linux-kernel@vger.kernel.org, kasey.erickson@gmail.com
Subject: Re: O_NONBLOCK is NOOP on block devices
Message-ID: <20100303115012.51ac89c7@lxorguk.ukuu.org.uk>
In-Reply-To: <201003030826.o238QWXK015588@alien.loup.net>
References: <201003030826.o238QWXK015588@alien.loup.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If O_NONBLOCK is meaningful whatsoever (see man page docs for
> semantics) against block devices, one would expect a nonblocking io

It isn't...

The manual page says "When possible, the file is opened in non-blocking
mode" . Your write is probably not blocking - but the memory allocation
for it is forcing other data to disk to make room. ie it didn't block it
was just "slow".

O_NONBLOCK on a regular file does influence how it responds to leases and
mandatory locks.

> probably be documented for clarity and it would be straight forward
> for it to return an error if these contradictory behaviors are
> simultaneously specified, unintentionally of course.

and risk breaking existing apps.

> Thoughts anyone?


Alan
