Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYJVJdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYJVJdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYJVJdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:33:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37899 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754693AbYJVJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:33:29 -0400
Date: Wed, 22 Oct 2008 10:32:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix n_tty/pty input/output buffer full and other misc
 char handling
Message-ID: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <48F2E450.1070508@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
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

> that ^C, ^Q, etc. can have effect) in non-canonical mode?  This would
> allow prevention of the gridlocks that still can be invoked when using
> stty -icanon in, say, an xterm.  For now, I took the conservative route
> in this patch, but let me know if a more permissive approach is better.

I suspect having thought about this a bit more that the proper logic is
in fact

	if (special case a)
	if (special case b)
	if (....)

	/* An ordinary character for the queue */
	if (queue_full) { ....}

and we should process everything that may have a special effect (flow
control, delete line, etc) before worrying about having room to store the
character whatever the tty ldisc state
