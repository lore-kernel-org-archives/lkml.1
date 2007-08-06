Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbXHFSjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbXHFSjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXHFSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:39:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbXHFSj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:39:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Date: Mon, 6 Aug 2007 20:48:36 +0200
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, "Pavel Machek" <pavel@ucw.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com> <200708061650.16555.rjw@sisk.pl> <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
In-Reply-To: <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062048.37160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 17:50, Joonwoo Park wrote:
> 2007/8/6, Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
> > > Hi.
> > > I think that the pci_set_power_state() has bug.
> > > The specification says that some delays is required.
> >
> > And they are in place, AFAICS (from drivers/pci/pci.c):
> >
> >        /* Mandatory power management transition delays */
> >        /* see PCI PM 1.1 5.6.1 table 18 */
> >        if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
> >                msleep(pci_pm_d3_delay);
> >        else if (state == PCI_D2 || dev->current_state == PCI_D2)
> >                udelay(200);
> >
> 
> The problem is occurred when state is 'PCI_D0', so those codes can't cover it.
> But pci pm specification 5.4.1 says that when programmed to D0 the
> equivalent of a warm reset, delay for the duration of the D3hot to D0
> Uninitialized state
> transition (10ms) to pci signal drivers remain disabled is required.

Section 5.4.1 of PCI PM 1.1. spec is about D3_hot.  Specifically, it says
that if a device in D3_hot is programmed to D0, it performs the equivalent of
a warm reset.  IOW, this is supposed to happen if the current state is D3_hot
and the targed state is D0, which is covered by the code snippet above.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
