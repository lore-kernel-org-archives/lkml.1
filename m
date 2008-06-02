Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYFBI0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYFBI0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYFBI0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:26:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44987 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752130AbYFBI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:26:07 -0400
Date: Mon, 2 Jun 2008 09:10:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Harald Dunkel <harald.dunkel@t-online.de>, Joe Peterson <joe@skyrush.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602091016.571dda7c@core>
In-Reply-To: <20080602053256.GF5609@1wt.eu>
References: <48434D57.6030801@skyrush.com>
	<48438126.3080308@t-online.de>
	<20080602053256.GF5609@1wt.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Guys, you should test if "kill -CONT $pid" wakes the process up.
> It might be possible that some obscure bug appeared in the tty
> code resulting in SIGTTOU sometimes being sent to the caller,
> although that seems rather strange :-/

Not really. The task would get suspended if it attempted to change the
tty settings while not being session leader. This is part of the POSIX
and BSD job control. A race (either kernel or in something like
sshd/bash) would do that and could have been caused by any of the timing
changes recently.

That would also explain why I can't duplicate it, and the sleep
observation.
