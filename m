Return-Path: <linux-kernel-owner+w=401wt.eu-S1765329AbXEYTpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765329AbXEYTpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764788AbXEYTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:45:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:53934 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764384AbXEYTpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:45:42 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+9NqJAE6W9Lk+Sn8nwJS5zwt4Op6JtcQkr8KCXda
	IeMvHHBKX3dAs3
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Fri, 25 May 2007 21:40:22 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705251759.30065.uwe.bugla@gmx.de> <200705252048.11931.maxi@daemonizer.de>
In-Reply-To: <200705252048.11931.maxi@daemonizer.de>
Cc: linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Buesch, Michael" <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252140.22635.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 25. Mai 2007 20:48 schrieben Sie:
> On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:
> > Perhaps someone reading this could try to reproduce that problem on his
> > machine.
> > Now who of the readers owes a Broadcom 4401 NIC and can please try to
> > test kernel 2.6.22-rc2-mm1?
> >
> > Those NICs have been used very very often as onboard controllers,
> > especially on ASUS boards.
>
> I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc2-
> mm1 and both work fine with the BCM4401 in my laptop.
>
> Maxi

Hello Maxi,

That may be true for your Laptop, but it unfortunately isn't true for my ASUS 
mainboard onboard controller.

Unfortunately I cannot confirm this:

My broadcom 4401 driver is not part of a notebook, but instead part of an ASUS 
P4PE mainboard.

At my second attempt I went the conventional path (i. e. ignoring the fact 
that
"Broadcom 4400 ethernet support appears twice in section "Network device 
support":

Whether you leave out "EISA, VLB, PCI and on board controllers" or not it 
simply appears twice in kernel config! This is bug number 1.

Conventional path means:

EISA, VLB, PCI and on board controllers Y

Broadcom 4400 ethernet support m

Broadcom 4400 PCI device support Y

This configuration binds:

Sonics Silicon Backplane Support m

Support for SSB on PCI-bus host

SSB PCI core driver

This time I do get a "good" interrupt: IRQ 21 for the the device.

BUT:

Trying to ping another machine fails saying:

"destination host unreachable"


That means, Although the interrupt is fine now, the device is still not 
functionable.

This is bug number 2.

Cheers

Uwe

P. S.: Michael, Andrew, if you need additional information to resolve that 
issue please tell / ask me.
