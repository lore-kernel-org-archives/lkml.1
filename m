Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYJLIwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYJLIwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJLIwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:52:33 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:19614 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbYJLIwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:52:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAFNX8UhR9c8S/2dsb2JhbACBcrdNgWw
Date: Sun, 12 Oct 2008 10:52:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Flemming Frandsen <ff@nrvissing.net>,
       "George G. Davis" <gdavis@mvista.com>,
       Lennert Buytenhek <buytenh@marvell.com>,
       Oliver Schuster <olivers137@aol.com>,
       Renaud Cerrato <r.cerrato@til-technologies.fr>,
       Sylver Bruneau <sylver.bruneau@googlemail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [WATCHDOG] v2.6.28-rc1 watchdog patches - part 1
Message-ID: <20081012085210.GB30246@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The first set of watchdog patches.

Can you please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 arch/arm/mach-orion5x/include/mach/orion5x.h |    2 
 arch/arm/plat-omap/devices.c                 |   21 
 drivers/watchdog/Kconfig                     |   43 +
 drivers/watchdog/Makefile                    |    4 
 drivers/watchdog/at91sam9_wdt.c              |  328 ++++++++++++
 drivers/watchdog/it87_wdt.c                  |  725 +++++++++++++++++++++++++++
 drivers/watchdog/omap_wdt.c                  |  337 ++++++++----
 drivers/watchdog/omap_wdt.h                  |   28 -
 drivers/watchdog/orion5x_wdt.c               |  245 +++++++++
 drivers/watchdog/w83697ug_wdt.c              |  392 ++++++++++++++
 10 files changed, 1985 insertions(+), 140 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Oct 2 09:32:45 2008 +0000

    [WATCHDOG] orion5x_wdt.c: add spinlocking
    
    Add spin_locking to orion5x_wdt.c to prevent races.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Sylver Bruneau <sylver.bruneau@googlemail.com>
Date:   Thu Jun 26 10:47:45 2008 +0200

    [WATCHDOG] Orion: add hardware watchdog support
    
    This patch allows the use of the hardware watchdog in the
    Marvell Orion series of ARM SoCs.
    
    Signed-off-by: Sylver Bruneau <sylver.bruneau@googlemail.com>
    Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Felipe Balbi <felipe.balbi@nokia.com>
Date:   Sat Sep 20 04:14:03 2008 +0300

    [WATCHDOG] omap_wdt.c: cleanup a bit omap_wdt.c
    
    Trivial cleanup patch.
    
    Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Felipe Balbi <felipe.balbi@nokia.com>
Date:   Sat Sep 20 04:14:02 2008 +0300

    [WATCHDOG] omap_wdt.c: another ioremap() fix
    
    convert to use ioremap() and __raw_{read/write} friends.
    
    Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
    Signed-off-by: George G. Davis <gdavis@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Felipe Balbi <felipe.balbi@nokia.com>
Date:   Sat Sep 20 04:14:01 2008 +0300

    [WATCHDOG] omap_wdt.c: sync linux-omap changes
    
    These are changes that have been sitting in linux-omap
    and were never sent upstream.
    
    Hopefully, it'll never happen again at least for this
    driver.
    
    Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Renaud CERRATO <r.cerrato@til-technologies.fr>
Date:   Mon Jun 23 17:05:49 2008 +0200

    [WATCHDOG] Add AT91SAM9X watchdog
    
    Add a driver for the watchdog timer embedded into AT91SAM9X chips.
    
    Signed-off-by: Renaud Cerrato <r.cerrato@til-technologies.fr>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Flemming Frandsen <ff@nrvissing.net>
Date:   Thu Apr 17 11:29:54 2008 +0200

    [WATCHDOG] Add driver for winbond w83697ug/uf watchdog feature
    
    Adapted the w83627hf_wdt.c driver to work with the w83697ug/uf chip,
    found on MSI Fuzzy CX700 boards.
    
    The method used is taken directly from the winbond datasheet and
    surprisingly it differs slightly from all the other winbond watchdogs.
    
    So far it has only been tested on the CX700 board that I have, but it
    seems to work nicely.
    
    Signed-off-by: Flemming Frandsen <ff@nrvissing.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Oliver Schuster <olivers137@aol.com>
Date:   Wed Mar 5 16:48:45 2008 +0100

    [WATCHDOG] add watchdog driver IT8716 IT8726 IT8712J/K
    
    Add it87xx watchdog driver
    IT8716 IT8718 IT8726 IT8712-J IT8712-K
    
    Signed-off-by: Oliver Schuster <olivers137@aol.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

Greetings,
Wim.

