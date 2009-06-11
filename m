Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZFKSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZFKSzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZFKSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:55:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:23034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZFKSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:55:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="420946313"
Date: Thu, 11 Jun 2009 11:54:58 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI PM: Read device power state from register after
 updating it
Message-ID: <20090611115458.66650e04@jbarnes-g45>
In-Reply-To: <200905262152.29489.rjw@sisk.pl>
References: <200905182246.41129.rjw@sisk.pl>
	<200905182252.21478.rjw@sisk.pl>
	<200905262152.29489.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 21:52:29 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 18 May 2009, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > After attempting to change the power state of a PCI device
> > pci_raw_set_power_state() doesn't check if the value it wrote into
> > the device's PCI_PM_CTRL register has been stored in there.  Still,
> > it modifies the device's current_state field as though that's the
> > case.  This may cause the driver of the device to think that its
> > power state has been changed while in fact it hasn't.
> > 
> > To prevent such situations from happening modify
> > pci_raw_set_power_state() so that it reads the device's PCI_PM_CTRL
> > register after writing into it and uses the value read from the
> > register to update the device's current_state field.  Also make it
> > return -EIO if the new state of the device is not equal to the state
> > requested by the called.
> > 
> > To distinguish this error condition from the other ones make
> > pci_raw_set_power_state() return -ENOSYS instead of -EIO when it is
> > impossible to change the power state of the device, because it
> > doesn't support the native PCI PM at all or the requested target
> > state is not supported by it.
> 
> Having reconsidered it I think that -ENODEV is probably better than
> -ENOSYS for this purpose.  Updated patch follows.

Applied to linux-next, thanks Rafael.

-- 
Jesse Barnes, Intel Open Source Technology Center
