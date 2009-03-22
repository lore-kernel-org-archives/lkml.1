Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZCVVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZCVVOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZCVVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:13:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbZCVVNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:13:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH 0/2] Make radeonfb use PCI PM core for suspendig device (was: Re: [RFC][PATCH] PCI PM: Be extra careful when changing power states of devices)
Date: Sun, 22 Mar 2009 22:08:21 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903210003.55161.rjw@sisk.pl>
In-Reply-To: <200903210003.55161.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222208.22434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 March 2009, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846 shows
> that setting the power state of a PCI device by
> pci_raw_set_power_state() may sometimes fail.  For this reason,
> pci_raw_set_power_state() should not assume that the power state of
> the device has actually changed after writing into its PMCSR.
> Instead, it should read the value from there and use it to update
> dev->current_state.  It also is useful to print a warning if the
> device's power state hasn't changed as expected.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
OK, since the Ben's radeonfb fix for bug #12846 has been merged, I'd like
to do something a bit different.

Patch 1/2 introduces __pci_set_power_state() that will allow the radeonfb
driver not to open code PCI PM operations.

Patch 2/2 makes the driver use __pci_set_power_state().

Comments welcome.

Thanks,
Rafael

