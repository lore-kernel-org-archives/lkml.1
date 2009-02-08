Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZBHXs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZBHXs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZBHXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:48:49 -0500
Received: from aun.it.uu.se ([130.238.12.36]:40615 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZBHXss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:48:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18831.28471.454273.451912@harpo.it.uu.se>
Date: Mon, 9 Feb 2009 00:48:07 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
In-Reply-To: <498F5A25.90707@ru.mvista.com>
References: <200902082253.07438.sshtylyov@ru.mvista.com>
	<Pine.LNX.4.64.0902082108290.18661@blonde.anvils>
	<498F5A25.90707@ru.mvista.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov writes:
 > Hello.
 > 
 > Hugh Dickins wrote:
 > 
 > >> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d (libata: Add 32bit PIO support)
 > >> caused all kind of errors on the ATAPI devices, so it's been empirically proven
 > >> that one shouldn't read/write an extra data word when a device isn't expecting
 > >> it already. "Don't do it then"; however still taking a chance to use 32-bit I/O
 > >> one last  time when there are exactly 3 trailing bytes.  Oh, and stop pointless
 > >> swapping bytes to and fro as well by using io*_rep() which shouldn't byte-swap.
 > >>
 > >> This should fix the kernel.org bug #12609.
 > >>
 > >> ---
 > >> This is hopefully better replacement for Hugh Dickins most recent patch
 > >> (http://marc.info/?l=linux-ide&m=123352294619281)...
 > >>     
 > >
 > > Yes, looks nice, and works for me.  My only criticism would be,
 > > minor issue unchanged by your patch, that actually "slop" isn't
 > > unlikely enough to deserve an "unlikely" - slop of 1 or 3 is
 > > unlikely, but slop of 2 is quite common.
 > >   
 > 
 >    I guess that's the case only for the ATAPI devices, so I'm going to 
 > keep it.

I really don't think it's a good idea to play micro-optimisation
unlikely() tricks when the likelihood depends on what kind of device
the driver is talking to. In this case unlikely() is clearly wrong.
