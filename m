Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYLEVYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYLEVYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLEVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:24:30 -0500
Received: from netgear.net.ru ([195.178.208.66]:47399 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYLEVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:24:30 -0500
Date: Sat, 6 Dec 2008 00:24:28 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081205212428.GB8075@ioremap.net>
References: <20081205180350.GA25236@ioremap.net> <20081205181610.518ecd13@lxorguk.ukuu.org.uk> <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com> <20081205192755.GA27712@ioremap.net> <20081205193432.290a6f1a@lxorguk.ukuu.org.uk> <20081205211223.GA8075@ioremap.net> <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 10:17:01PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> > And what's with tty drivers? If kernel freezes there even if suddenly
> > faulty userspace started to load them, where this can happen? Apparently
> > it is not sleeping userspace since console does not respond to input.
> 
> 5-1 dev_t request looks like something in initramfs accesses
> /dev/console, but the driver for it is not properly
> initialized/registered that time, and the kernel module loader tries
> to load a module? The forked process might also try to access
> /dev/console again, and hence the loop?

But why system freezes? Is this init linking/__init calling order
changes? I have all tty/8250 compiled in btw.

$ egrep -i "console|tty|8250" /tmp/.config 
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# Non-8250 serial port support
CONFIG_SERIAL_CORE_CONSOLE=y
# Console display driver support
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y

-- 
	Evgeniy Polyakov
