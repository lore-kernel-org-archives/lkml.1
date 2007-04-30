Return-Path: <linux-kernel-owner+w=401wt.eu-S1946552AbXD3SPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946552AbXD3SPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946553AbXD3SPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:15:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946552AbXD3SPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:15:47 -0400
Date: Mon, 30 Apr 2007 11:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, helge.hafting@aitel.hist.no,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
Message-Id: <20070430111414.0eefd4b0.akpm@linux-foundation.org>
In-Reply-To: <20070430172547.204810@gmx.net>
References: <20070429182209.267430@gmx.net>
	<alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
	<20070429205925.129920@gmx.net>
	<alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
	<20070429230037.95120@gmx.net>
	<1177894713.3046.5.camel@pc06.localdom.local>
	<20070430110255.267000@gmx.net>
	<4635D139.4030609@aitel.hist.no>
	<20070430115000.194060@gmx.net>
	<4636058B.3070603@aitel.hist.no>
	<Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
	<20070430172547.204810@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 19:25:47 +0200
"Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> I did not manage to at least find one single unresolved module during compilation, and I have been working with this almost fantastic solution with several kernels for months now!

That isn't what Mauro is saying.  What he is saying is that the missing
symbols will not be reported at build time.  The kernel will all link
correctly and will appear to load modules correctly.

See, there's a third mechanism for symbol resolution which is used at
runtime, not at build time: symbol_request().

What Mauro is saying is that these changes will cause symbol_request() to
return different results on some people's setups with different hardware,
causing those setups to fail.

