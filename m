Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYHKQ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYHKQ43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYHKQ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:56:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39607 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687AbYHKQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:56:20 -0400
Date: Mon, 11 Aug 2008 17:39:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
Message-ID: <20080811173911.07a3a9c5@lxorguk.ukuu.org.uk>
In-Reply-To: <48A0573B.4010602@skyrush.com>
References: <48977C96.2090005@skyrush.com>
	<20080805001129.72d06e60@lxorguk.ukuu.org.uk>
	<489A06D9.1080600@skyrush.com>
	<20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
	<48A0573B.4010602@skyrush.com>
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

> I am working up an echo buffer (fifo) that would hold these characters until
> they can be sent (if the write is not possible), but since that means they
> will arrive at the tty later, their interleaving within the application output
> stream is not guaranteed, which again is a problem for the column logic.
> 
> I'm still looking into it - not trivial for sure...

First thought would be to simply fire all output through your buffer in
n_tty. It's not a performance critical bit of code and it would still be
fast as the usual case would be

	if (queue->length == 0)
		try_write_directly(...)
