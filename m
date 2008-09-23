Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYIWKqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYIWKqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYIWKqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:46:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbYIWKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:46:29 -0400
Date: Tue, 23 Sep 2008 11:39:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: How to kick a secondary watchdog? (Re: [PATCH 1/3] watchdog:
 sync linux-omap changes)
Message-ID: <20080923113929.3691e51e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080923102159.GD5102@atomide.com>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com>
	<1221873243-18303-2-git-send-email-me@felipebalbi.com>
	<20080922182206.GM22550@infomag.infomag.iguana.be>
	<20080922191353.GB8314@flint.arm.linux.org.uk>
	<20080923083915.GS22550@infomag.infomag.iguana.be>
	<20080923102159.GD5102@atomide.com>
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

> Some omap devices like Nokia 770, N800 and N810 have also a secondary
> watchdog on the retu chip connected via cbus. This watchdog needs
> to be kicked as it cannot be disabled.

If you have a chip that runs continually then the easiest approach I've
seen is to have kernel code that manages it and the watchdog driver just
keeps a time value indicating whether it should be refreshed.

We've got a few watchdogs like that in the watchdog tree.

If it can be user started but then not stopped that is fine - the API
doesn't require you can stop it
