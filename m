Return-Path: <linux-kernel-owner+w=401wt.eu-S1750932AbXEXNpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932AbXEXNpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXEXNpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:45:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43576 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbXEXNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:45:29 -0400
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
	input/output speed
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070524144109.7bd0f4d0@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 24 May 2007 09:45:37 -0400
Message-Id: <1180014338.8303.95.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 14:41 +0100, Alan Cox wrote:
> Most people copied the x86 behaviour which makes it easy to transplant.
> Some are just smoking something (see ioctls.h for sh-64 and weep), others
> have slightly odd behaviour for historical compatibility reasons (Sparc)

Likewise, I assume the lack of IBSHIFT on PowerPC is because of AIX?

> > Presumably this is because of the mess in tty_termios_encode_baud_rate
> > when we fix its bogus assumptions about IBSHIFT always being defined?
> 
> It's not a bogus assumption. The current code supports
> 
> 	- The old way
> 	- BOTHER and IBSHIFT
> 
> When PPC wants to do arbitary baud rate it needs to resolve both of the
> definitions together. IBSHIFT is simply the shift you apply to the baud
> bits to get the input baud bits.

Why bother introducing new IBSHIFT stuff when it can be declared
obsolete already -- if you want different input and output baud rates,
just set BOTHER and have different values c_ispeed and c_ospeed.

That's what my patch attempts. It builds but I haven't actually tested
it. Why do you say it won't work?

-- 
dwmw2

