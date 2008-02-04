Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYBDVxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYBDVxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBDVxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:53:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYBDVxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:53:30 -0500
Subject: Re: [Wireless, ath5k] 2.6.24-git13
	9135f1901ee6449dfe338adf6e40e9c2025b8150
From: Dan Williams <dcbw@redhat.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bruno Randolf <bruno@thinktube.com>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ath5k-devel@lists.ath5k.org
In-Reply-To: <6101e8c40802041334o20b2b391la5b0a5f557ee67c5@mail.gmail.com>
References: <6101e8c40802040600q804e40cs97d0031920e58d9d@mail.gmail.com>
	 <47A774AB.5060008@gmail.com>
	 <6101e8c40802041334o20b2b391la5b0a5f557ee67c5@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 04 Feb 2008 16:52:14 -0500
Message-Id: <1202161934.24527.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 22:34 +0100, Oliver Pinter wrote:
> On 2/4/08, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 02/04/2008 03:00 PM, Oliver Pinter (Pintér Olivér) wrote:
> > > git top: 9135f1901ee6449dfe338adf6e40e9c2025b8150
> > >
> > > [  399.582185] wpa_supplicant[4383]: segfault at 30 ip 080697ca sp
> > > bf87a690 error 4 in wpa_supplicant[8048000+4c000]
> > > [  406.277199] wpa_supplicant[4384]: segfault at 30 ip 080697ca sp
> > > bfc13a30 error 4 in wpa_supplicant[8048000+4c000]
> > > [  407.586375] wpa_supplicant[4385]: segfault at 30 ip 080697ca sp
> > > bf9ed000 error 4 in wpa_supplicant[8048000+4c000]
> > > [  411.671037] wpa_supplicant[4386]: segfault at 30 ip 080697ca sp
> > > bf8f3710 error 4 in wpa_supplicant[8048000+4c000]
> > > [  412.569843] wpa_supplicant[4387]: segfault at 30 ip 080697ca sp
> > > bfc19a30 error 4 in wpa_supplicant[8048000+4c000]
> > > [  413.118874] wpa_supplicant[4388]: segfault at 30 ip 080697ca sp
> > > bfc9cab0 error 4 in wpa_supplicant[8048000+4c000]
> >
> > Seems like wpa_supplicant is broken. Is this a regression?
> 
> yes, but with madwifi is all ok
> >
> > > home:~# wpa_supplicant -Dwext -iath0 -c
> > /etc/wpa_supplicant/wpa_supplicant.conf
> >
> > ath0? udev renamed it?
> 
> yes
> >
> > > ioctl[SIOCSIWAUTH]: Operation not supported
> > > WEXT auth param 4 value 0x0 - bind(PF_UNIX): Address already in use
> >
> > 4 - 0x0 is TKIP, nothing we should worry about.
> >
> > > ctrl_iface exists and seems to be in use - cannot override it
> > > Delete '/var/run/wpa_supplicant/ath0' manually if it is not used anymore
> > > Failed to initialize control interface '/var/run/wpa_supplicant'.
> > > You may have another wpa_supplicant process already running or the file
> > was
> > > left by an unclean termination of wpa_supplicant in which case you will
> > need
> > > to manually remove this file before starting wpa_supplicant again.
> >
> > Have you?
> 
> yes
> >
> > I guess ltrace would help here. And maybe strace...
> >
> 
> strace attached and wpa_supplicant more verbose output

It doesn't look like the driver is returning _any_ scan results.  What
does '/sbin/iwlist wlan0 scan' show from the command line.  If the
driver isn't returning scan results to the supplicant, there's not much
the supplicant can do.  You may need to ensure the interface is up
before scanning.

Note that the specific behavior of the process requesting scan results
can sometimes interact badly with the driver.  The driver most likely
needs to cope with this (by caching the BSS list internally for example)
and handle whatever behavior userspace programs throw at it.

Dan

