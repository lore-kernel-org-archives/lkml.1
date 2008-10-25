Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYJYPl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYJYPl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJYPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:41:18 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:46859 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYJYPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:41:17 -0400
Message-ID: <49033E1B.9030406@skyrush.com>
Date: Sat, 25 Oct 2008 09:41:15 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] n-tty-output-bells-immediately
References: <48F2E450.1070508@skyrush.com>	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>	<48FFD4F9.6090105@skyrush.com> <20081024101029.6e826234@lxorguk.ukuu.org.uk>
In-Reply-To: <20081024101029.6e826234@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Ok without randomly hitting send this time...
> 
> LC/UC and control characters looks right.  (except the added white space)
> Buffer sizing looks fine
> Bell definitely a good idea
> 
> Those three applied with better subject lines and queued for .29
> 
> The last one I'm rather less happy with but want to ponder a bit more the
> best way to handle.

All sounds good - thanks.  Yes, let's think a bit more about the last
one.  The problem, as I see it now, is that only the ldisc knows how to
treat certain chars, but the input buffers get clogged before they get
to the ldisc.  Perhaps devising a way for upstream input code to call
the ldisc to inform it that there is a "signal pending/queued" (i.e.
SIGINT, SIGQUIT, SIGSTP) or a tty restart (e.g. ^Q) queued...

BTW, where are the patches sitting at this point?  I saw an email about
"linux-next" that lists just the first of the 3 (the drop bkl one); and
your tty git is now empty.  Just curious.

					Thanks!  Joe
