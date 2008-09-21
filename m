Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYIUOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYIUOS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYIUOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:18:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60727 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbYIUOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:18:19 -0400
Date: Sun, 21 Sep 2008 15:18:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkml@pengaru.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20080921151811.46328133@lxorguk.ukuu.org.uk>
In-Reply-To: <20080921092442.GS2761@fc6222126.aspadmin.net>
References: <20080920214229.GP2761@fc6222126.aspadmin.net>
	<20080920.152140.193698477.davem@davemloft.net>
	<20080920230046.GQ2761@fc6222126.aspadmin.net>
	<20080921092442.GS2761@fc6222126.aspadmin.net>
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

> > You might also want to look at the socket(7) man page which implies that
> > what Linux currently does is exceptional & incorrect:

Actually we follow 1003.1g draft 6.4 which is about as close as there
ever was a spec for BSD sockets. We go beyond it actually -
SO_RCVLOWAT/SO_SNDLOWAT are in fact optional.

> SO_RCVLOWAT, and to my surprise even my recv() calls with MSG_PEEK flags
> set are not blocking.  They block without MSG_PEEK, but not with.

Correct and we've always done that intentionally.

> At this point, for my application to work on Linux without burning CPU like
> mad... I basically have to sleep and poll the socket regularly to see if
> more data has arrived with the tcp socket ioctl SIOCINQ. :(

What are you actually trying to do ? The usual way to handle urgent data
in those odd cases that use it is to select for an exception event.

Alan
