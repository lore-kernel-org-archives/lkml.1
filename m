Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYJ0QFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYJ0QFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYJ0QFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:05:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36858 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbYJ0QFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:05:23 -0400
Date: Mon, 27 Oct 2008 16:03:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
Message-ID: <20081027160359.37db885c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org>
References: <1224168620.9617.14.camel@localhost>
	<1224230354.4631.1.camel@localhost>
	<20081021092148.GB4980@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org>
	<20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org>
	<1225049195.14057.72.camel@localhost>
	<alpine.LFD.2.00.0810261212290.5200@nehalem.linux-foundation.org>
	<1225101688.15777.6.camel@localhost>
	<alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org>
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

> And as for the actual explanations: either they need to be totally outside 
> the kernel (in a project of their own), or they'd need to be "kernel-doc" 
> style things that are _in_ the source code. Not in Documentation/. Not 
> separate from the printk() that they are associated with.

You really don't want 32 languages in mixed left/right rendering with
multiple fonts in your kernel source. At least not with most editing and
viewing tools....

User space uses message catalogues and has tools for maintaining them
which make using any other format somewhat dumb. They extract strings
using _("hello") type wrappers to identify what are translatable strings
so if the kernel source has _() macros all the tooling just works and can
live outside and way from the kernel.

Just needs _() to do the right thing compiled into the kernel and a
printk formatting to do the right thing with the result. In truth you
don't even need a hash in printk just the ability to make it produce
either

	"Hello my name is 'fred3'"

and something like

	"Hello my name is '%s%d'\0Fred\0\000\000\000\003"

The kernel contains the English which should be a pretty passable hash.

Alan
