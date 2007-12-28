Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXL1HVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXL1HVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXL1HVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:21:19 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36081 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXL1HVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:21:18 -0500
Date: Fri, 28 Dec 2007 08:21:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
Message-ID: <20071228072116.GA16553@rhlx01.hs-esslingen.de>
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com> <1197003097.13978.557.camel@pmac.infradead.org> <20071207022342.806ee4ee.akpm@linux-foundation.org> <20071227174056.GA17350@rhlx01.hs-esslingen.de> <20071227184145.GA1831@martell.zuzino.mipt.ru> <20071227221728.GA17379@rhlx01.hs-esslingen.de> <20071228062201.GA2071@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228062201.GA2071@martell.zuzino.mipt.ru>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 28, 2007 at 09:22:01AM +0300, Alexey Dobriyan wrote:
> On Thu, Dec 27, 2007 at 11:17:28PM +0100, Andreas Mohr wrote:
> > And this is the state that my 2.6.24-rc_six_-mm1 tree is in already.
> 
> OK.
> 
> > So either it didn't help here or it broke again by some later change or
> > there's some dumb PEBKAC error here.
> 
> Do you by chance forgot CONFIG_USB_?HCI_HCD=y ? I see empty usbfs here if
> they are deselected.

Quite well-educated guess! In fact I had already discovered that
ohci-hcd fails to load, at all. Doh.
(however after going through all recent ohci.*hcd related LKML postings
it seems there's no report about such problems yet)

Sorry for barking up the entirely wrong tree!

For giggles, here's the output:

# modprobe ohci-hcd
FATAL: Error inserting ohci_hcd (/lib/modules/2.6.24-rc6-mm1-gate/kernel/drivers/usb/host/ohci-hcd.ko): No such device

dmesg:
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64

(yes, that's all there is, despite CONFIG_USB_DEBUG being set)

The LED of a usb stick isn't active either, for obvious reasons.

And keep in mind that this is a (relatively old) OHCI-only machine...
(which had the 2.6.19 lsmod showing ohci-hcd just fine and working fine
with WLAN USB)

Now pondering whether to try -rc6 proper or whether to revert specific
guilty-looking USB changes...
And wondering how to properly elevate this issue (prompt Greg about it,
new thread, bug #, ...?)

Thanks,

Andreas Mohr
