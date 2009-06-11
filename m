Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZFKTxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZFKTxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZFKTw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:52:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbZFKTw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [PATCH 2/2] PCI PM: Read device power state from register after updating it
Date: Thu, 11 Jun 2009 21:53:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
References: <200905182246.41129.rjw@sisk.pl> <200905262152.29489.rjw@sisk.pl> <20090611115458.66650e04@jbarnes-g45>
In-Reply-To: <20090611115458.66650e04@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112153.16853.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Jesse Barnes wrote:
> On Tue, 26 May 2009 21:52:29 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday 18 May 2009, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > After attempting to change the power state of a PCI device
> > > pci_raw_set_power_state() doesn't check if the value it wrote into
> > > the device's PCI_PM_CTRL register has been stored in there.  Still,
> > > it modifies the device's current_state field as though that's the
> > > case.  This may cause the driver of the device to think that its
> > > power state has been changed while in fact it hasn't.
> > > 
> > > To prevent such situations from happening modify
> > > pci_raw_set_power_state() so that it reads the device's PCI_PM_CTRL
> > > register after writing into it and uses the value read from the
> > > register to update the device's current_state field.  Also make it
> > > return -EIO if the new state of the device is not equal to the state
> > > requested by the called.
> > > 
> > > To distinguish this error condition from the other ones make
> > > pci_raw_set_power_state() return -ENOSYS instead of -EIO when it is
> > > impossible to change the power state of the device, because it
> > > doesn't support the native PCI PM at all or the requested target
> > > state is not supported by it.
> > 
> > Having reconsidered it I think that -ENODEV is probably better than
> > -ENOSYS for this purpose.  Updated patch follows.
> 
> Applied to linux-next, thanks Rafael.

Please drop.  It has been reported by Jiri to cause a regression to happen.

Best,
Rafael
