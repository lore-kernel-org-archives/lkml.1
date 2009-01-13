Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZAMMXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZAMMXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZAMMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:23:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39472 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753202AbZAMMXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:23:35 -0500
Date: Tue, 13 Jan 2009 12:23:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [tty bug] kernel BUG at drivers/char/tty_ldisc.c:359!
Message-ID: <20090113122338.13a155a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113121039.GA22155@elte.hu>
References: <20090113121039.GA22155@elte.hu>
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

On Tue, 13 Jan 2009 13:10:39 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> FYI, -tip testing found a new warning in drivers/char/tty_ldisc.c:

Thanks - yes there is a real bug that is exposed by the BKL drop if you
manage to hit the flush ioctl as the ldisc changes 

Change the 
	ld = tty_ldisc_ref(tty)

to
	ld = tty_ldisc_ref_wait(tty);

