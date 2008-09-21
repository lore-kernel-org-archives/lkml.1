Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYIUUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYIUUNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIUUNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:13:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57096 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbYIUUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:13:40 -0400
Date: Sun, 21 Sep 2008 21:13:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vcaputo@pengaru.com, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080921145134.GT2761@fc6222126.aspadmin.net>
References: <20080920214229.GP2761@fc6222126.aspadmin.net>
	<20080920.152140.193698477.davem@davemloft.net>
	<20080920230046.GQ2761@fc6222126.aspadmin.net>
	<20080921092442.GS2761@fc6222126.aspadmin.net>
	<20080921151811.46328133@lxorguk.ukuu.org.uk>
	<20080921145134.GT2761@fc6222126.aspadmin.net>
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

Thats a gloriously insane way of trying to do HTTP/1.1, and one I'm not
sure is actually viable in the real world because the TCP window may be
smaller than the number of bytes required to find a Host: header - so you
may simply not be able to receive it via MSG_PEEK. In particular mobile
phone gateways have a nasty habit of using very small windows.

> I just don't see a good solution for what I'm doing other than MSG_PEEK
> and SO_RCVLOWAT, any ideas?

I don't either, and while I don't agree that what you are doing for
HTTP/1.1 is remotely sane there are probably other cases this would be
both sane and useful which does suggest fixing it would be beneficial
