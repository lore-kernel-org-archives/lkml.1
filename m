Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXGXQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXGXQ5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXGXQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:57:14 -0400
Received: from gw.goop.org ([64.81.55.164]:37380 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXGXQ5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:57:13 -0400
Message-ID: <46A62F35.2000501@goop.org>
Date: Tue, 24 Jul 2007 09:56:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <20070724153916.GS21668@ftp.linux.org.uk>
In-Reply-To: <20070724153916.GS21668@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 	AFAICS, the patch below should do it for i386; instead of
> using a dummy loop to tell gcc that this sucker never returns,
> we do
> static void __always_inline __noreturn __BUG(const char *file, int line);
> containing the actual asm we want to insert and define BUG() as
> __BUG(__FILE__, __LINE__).  It looks safe, but I don't claim enough
> experience with gcc __asm__ potential nastiness, so...
>
> Comments, objections?
>   

Does it work?  When I wrote the BUG code I tried this, but gcc kept
warning about "noreturn function returns".  I couldn't work out a way to
convince gcc that the asm is the end of the line.

I'm actually in favour of dropping the loop and the noreturn stuff
altogether.  It means that gcc thinks everything is live at the time of
the BUG, and the debugging info at the point of the ud2a is more useful.

    J
