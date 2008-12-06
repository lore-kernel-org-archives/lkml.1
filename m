Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYLFOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYLFOK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYLFOKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:10:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbYLFOKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:10:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/3] Fix hibernation regression on Toshiba Portege R500
Date: Sat, 6 Dec 2008 15:05:33 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl>
In-Reply-To: <200812020320.31876.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812061505.33815.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches address the hibernation/suspend issue described in
http://bugzilla.kernel.org/show_bug.cgi?id=12121 and in the very long thread at
http://lkml.org/lkml/2008/12/1/382.

In short, the problem is that resume (from hibernation and/or suspend-to-RAM)
occasionally fails (approximately 20-25% of attempts) in the middle of resuming
PCI devices.  We were able to find a specific layout of devices within the
memory address space in which the failure appeared to be extremely unlikely,
but this layout was no really valid for other reasons.  We also found out that
using the NMI watchdog decreased the probablitily of failure which indicated
that the problem could be timing-related.

Next, we started to look at the PCI resume code and we generally agreed that
it would be a good idea to restore the standard PCI configuration registers
with interrupts disabled.  Also, we thought we could move the saving of those
registers for some devices into functions executed with interrupts disabled.

I have followed these observations and created the three following patches.
With all of these patches applied, I'm not able to reproduce the problem.

Thanks,
Rafael

