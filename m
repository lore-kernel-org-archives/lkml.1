Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbYHDX2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbYHDX2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYHDX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:28:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754682AbYHDX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:28:39 -0400
Date: Tue, 5 Aug 2008 00:11:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
Message-ID: <20080805001129.72d06e60@lxorguk.ukuu.org.uk>
In-Reply-To: <48977C96.2090005@skyrush.com>
References: <48977C96.2090005@skyrush.com>
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

On Mon, 04 Aug 2008 16:03:02 -0600
Joe Peterson <joe@skyrush.com> wrote:

> I am experiencing a rather intermittent and hard-to-reproduce issue in the tty
> layer, and I am posting here to get ideas on how to debug it from those of you
> who have delved into the tty internals.  I suspect some kind of race is going on
> or the echo is caught in the tty buffer when it gets flushed (and never makes it
> to the tty).  Heavy load (compiling, etc.) seems to make it more likely.
> 
> When a signal character (e.g. ctrl-c) is received, the tty ldisc and driver are
> flushed, the character is echoed (e.g. "^C" if echoctl is on), and the signal is
> issued.  Because the flush happens first, the echo should always appear on the
> tty, but sometimes it does not.  What I am wondering is how the echo could get
> "swallowed".  The code I have been using to test this is:

If the output buffer is full then echoed characters/^C etc will vanish the
way n_tty implements its buffering internally. It's always worked that
way.

Alan
