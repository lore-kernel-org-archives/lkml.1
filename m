Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYIYEA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYIYEA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYIYEAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:00:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60259
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbYIYEAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:00:48 -0400
Date: Wed, 24 Sep 2008 21:00:36 -0700 (PDT)
Message-Id: <20080924.210036.171431340.davem@davemloft.net>
To: airlied@gmail.com
Cc: jeff@garzik.org, jkosina@suse.cz, akpm@linux-foundation.org,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809242051x17785159ya7510d92f705f3cf@mail.gmail.com>
References: <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
	<48DAF75D.4050908@garzik.org>
	<21d7e9970809242051x17785159ya7510d92f705f3cf@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Thu, 25 Sep 2008 13:51:23 +1000

> I think e1000e may enable a BAR or something that causes the issue to
> break this hw., I haven't seen it broken on any
> machine where e1000e wasn't loaded yet. Again the r8169 might be the
> same issue, but it maybe because the bar was enabled.

All PCI device drivers in the kernel first do pci_enable_device()
which essentially enables all BARs.

The flash lives in BAR 1 of the E1000E, for example.
