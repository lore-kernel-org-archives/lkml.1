Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbZCWVdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbZCWVdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbZCWVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:33:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758375AbZCWVdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:33:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make radeonfb use it
Date: Mon, 23 Mar 2009 22:30:09 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903210003.55161.rjw@sisk.pl> <200903222208.22434.rjw@sisk.pl>
In-Reply-To: <200903222208.22434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232230.10831.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009, Rafael J. Wysocki wrote:
> On Saturday 21 March 2009, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846 shows
> > that setting the power state of a PCI device by
> > pci_raw_set_power_state() may sometimes fail.  For this reason,
> > pci_raw_set_power_state() should not assume that the power state of
> > the device has actually changed after writing into its PMCSR.
> > Instead, it should read the value from there and use it to update
> > dev->current_state.  It also is useful to print a warning if the
> > device's power state hasn't changed as expected.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> OK, since the Ben's radeonfb fix for bug #12846 has been merged, I'd like
> to do something a bit different.
> 
> Patch 1/2 introduces __pci_set_power_state() that will allow the radeonfb
> driver not to open code PCI PM operations.
> 
> Patch 2/2 makes the driver use __pci_set_power_state().
> 
> Comments welcome.

Well, Jesse doesn't like these patches very much, so here's an alternative.

1/2 changes platform_pci_set_power_state() into an exported function (and uses
it to simplify pci_set_power_state() a bit) so that the radeonfb driver can use
it.

2/2 modifies the radeonfb driver itself.

Thanks,
Rafael

