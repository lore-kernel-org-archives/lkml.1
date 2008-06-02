Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYFBRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYFBRP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFBRPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:15:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51093 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752203AbYFBRPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:15:21 -0400
Date: Mon, 2 Jun 2008 17:59:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
Message-ID: <20080602175946.366c5d64@core>
In-Reply-To: <20080602170916.GD16164@csclub.uwaterloo.ca>
References: <20080601161510.GA26854@enneenne.com>
	<20080602075113.60d0fdf8@core>
	<20080602092551.GC26854@enneenne.com>
	<20080602150257.54692f35@core>
	<20080602145603.GG26854@enneenne.com>
	<20080602170916.GD16164@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course if you have to check of the DCD changed, that may not be
> constant.  A check for whether this device currently has anyone that
> wants the timestamp though should be a constant time.

Not having to take the cost of that for other users is far more important
than a time variance of a jump prediction. CPU cache effects alone will
add way more variance already. It's not a meaningful number to chase
compared to the randomness introduced by the IRQ handling itself.

If you want perfect accuracy do what I²IT did years ago and use a card
which timestamps the physical IRQ bus transition and exposes it to the OS.

Alan
