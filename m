Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYHHMI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYHHMI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYHHMIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:08:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52765 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756043AbYHHMID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:08:03 -0400
Date: Fri, 8 Aug 2008 12:50:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kanru Chen <koster@debian.org.tw>
Cc: linux-kernel@vger.kernel.org, Kanru Chen <koster@debian.org.tw>
Subject: Re: [PATCH] tty_io: fix tiocswinsz, tiocgwinsz races.
Message-ID: <20080808125045.2d72b196@lxorguk.ukuu.org.uk>
In-Reply-To: <1218191778-5781-1-git-send-email-koster@debian.org.tw>
References: <1218191778-5781-1-git-send-email-koster@debian.org.tw>
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

On Fri,  8 Aug 2008 18:36:18 +0800
Kanru Chen <koster@debian.org.tw> wrote:

> real_tty may receive SIGWINCH before the new winsize is setted.

It needs rather more than that - for the moment I've gone back to the old
races because there is an awkward deadlock case to deal with. I've pushed
some changes to the -next tree to rework all this locking.

I had however missed the tty/real_tty case so something like your changes
might still be relevant. I'll take a look.
