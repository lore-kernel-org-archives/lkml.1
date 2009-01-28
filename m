Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbZA1U6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbZA1U6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZA1UlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:41:09 -0500
Received: from mail.perle.com ([216.129.13.248]:2831 "EHLO MAILV6.PERLE.COM"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757390AbZA1UlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:41:07 -0500
In-Reply-To: <20090122124042.7251ff0f@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF7AEEC39E.E1555596-ON8525754C.006E408A-8525754C.0071A192@perle.com>
From: bmckinlay@perle.com
Date: Wed, 28 Jan 2009 15:36:23 -0500
X-MIMETrack: Serialize by Router on MAILV6/Perle(Release 6.5.6FP3|March 27, 2008) at 01/28/2009
 03:36:10 PM,
	Serialize complete at 01/28/2009 03:36:10 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 01/22/2009 07:40:42 AM:
> > This patch seems to break any other pseudo tty drivers, (ie 
driver->type
> > ==TTY_DRIVER_TYPE_PTY) since not all the tty functions needed for the
> > driver's new driver->install method are exported from tty_io.c.  The
> > function symbols that need to be exported from /drivers/char/tty_io.c 
are

> I did ask at the time what other PTY drivers there were as and
> what .config case in the kernel needed those symbols. If you only need
> them for an out of tree driver then they can stay out of tree until that
> driver is merged.

So you are saying that if I merge my ptyx module into the kernel tree THEN 
these
exports would be added?  They would have to be, since I would still want 
my 
driver to be a module instead of statically linked with the kernel like 
pty is.

I think the fact that you had to "ask at the time what other PTY drivers 
there 
were" indicates that these symbols should have been simply exported to 
avoid 
any problems with out of tree PTY drivers.

By not exporting these symbols it means that the Linux kernel is now 
forcing 
anyone who wants to develop a PTY type TTY driver to be merged into the 
kernel 
tree by not exporting these TTY functions. This doesn't seem very "open 
and 
flexible".





