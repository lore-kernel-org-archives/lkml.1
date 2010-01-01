Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134Ab0AAUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0AAUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 15:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969Ab0AAUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 15:12:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38856 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0AAUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 15:12:37 -0500
Date: Fri, 1 Jan 2010 21:12:35 +0100
From: Andreas Mohr <andi@lisas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andreas Mohr <andi@lisas.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
Subject: Re: [PATCH] PCI / PM: Use per-device D3 delays
Message-ID: <20100101201235.GA31960@rhlx01.hs-esslingen.de>
References: <20100101170729.GA22252@rhlx01.hs-esslingen.de> <201001011955.27407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001011955.27407.rjw@sisk.pl>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 01, 2010 at 07:55:27PM +0100, Rafael J. Wysocki wrote:
> On Friday 01 January 2010, Andreas Mohr wrote:
> > Hi,
> > 
> > While the bug report mentions "So it's just quirky hardware.",
> > the implementation of your patch makes it seem like this delay attribute is
> > totally "norm"al behaviour - I'm missing some more aggressive wording.
> 
> That's because it works both ways (please look at the changelog).

Ah, ok.

> I know of a few devices that don't need the PCI-prescribed 10 ms wait when
> going from D3 to D0 and their drivers may use the d3_delay field to actually
> set a _shorter_ delay.

Then why is the value lower-bounded by pci_pm_d3_delay
(which, puzzlingly, was initialized to PCI_PM_D3_WAIT and thus 10
before, which the patch now removes!), in pci_dev_d3_sleep()?
(and pci_pm_d3_delay is being quirked in drivers/pci/quirks.c only,
to 120)

Confused,

Andreas Mohr
