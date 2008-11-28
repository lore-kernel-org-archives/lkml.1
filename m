Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYK1OD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYK1OD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYK1ODq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:03:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYK1ODq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:03:46 -0500
Date: Fri, 28 Nov 2008 09:03:35 -0500
From: Alan Cox <alan@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Message-ID: <20081128140335.GA21358@shell.devel.redhat.com>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com> <200811271531.18498.arnd@arndb.de> <1227810424.4277.55.camel@aiko.keithp.com> <200811281243.02841.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811281243.02841.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 12:43:02PM +0100, Arnd Bergmann wrote:
> I've just checked all tty device drivers. The only one using the file
> pointer in ->ioctl, ->tiocmget and ->tiocmset is serial_core, which
> passes it to tty_hung_up_p(). That could easily be changed to check
> (tty->flags & TTY_HUPPED) AFAICT.
> 
> Maybe Alan can comment on this. I think the code would become cleaner
> if we dropped the file argument to these three functions throughout
> the tty layer, but it's probably not worth the pain to change themm
> call.

Removing it seems a bit pointless as someone will one day no doubt need
to put it back again

