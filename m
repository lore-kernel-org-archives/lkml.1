Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbYD2Ko3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbYD2Ko3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761797AbYD2Kn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:43:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54100 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759069AbYD2Kn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:43:57 -0400
Date: Tue, 29 Apr 2008 11:34:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429113410.0971d071@core>
In-Reply-To: <20080429103335.GD1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu>
	<48167A07.4000305@kernel.org>
	<20080429050605.GA27875@1wt.eu>
	<20080429072911.GA28059@cs181133002.pp.htv.fi>
	<20080429081423.GD30507@1wt.eu>
	<4816E4FD.5060605@aitel.hist.no>
	<20080429100934.GB1473@1wt.eu>
	<20080429111014.5a065b88@core>
	<20080429103335.GD1473@1wt.eu>
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

> behaviour). The shell no, it was the one present on my machine and
> has never been compiled with UTF-8 support, and should not have to.

Bizarre, so you are using deliberately misconfigured ancient userspace to
complain about utf-8

> In my opinion, the problem is that when I press "é", the system sends
> two chars to the bash, which itself sends two chars to the terminal,
> which only displays one and moves the cursor one step ahead. Then,
> pressing backspace once sends one backspace all along, resulting in
> the terminal blanking one displayed char, but the shell not being

The shell puts the terminal in character by character mode and readline
does this. If you have your shell/readline deliberately set up not to be
doing unicode locales then it will do the wrong thing.

> So in my opinion, when we send one backspace to the terminal to
> remove one character, since there are two in the buffer, we
> should not get back one full char. Ideally, the console driver
> should send as many backspaces as needed to fix the multiple

The console driver isn't involved - readline took over for the shell, and
readline most definitely supports this in a utf8 locale.

Alan
