Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbZJFQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbZJFQJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbZJFQJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:09:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:28166 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974AbZJFQJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,513,1249282800"; 
   d="scan'208";a="195682169"
Date: Tue, 6 Oct 2009 09:08:55 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Andreas Mohr <andi@lisas.de>,
       kevin granade <kevin.granade@gmail.com>
Subject: Re: [Resend][PATCH] PCI PM: Read device power state from register
 after updating it
Message-ID: <20091006090855.650ef454@jbarnes-g45>
In-Reply-To: <200910050048.40699.rjw@sisk.pl>
References: <200910050048.40699.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009 00:48:40 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After attempting to change the power state of a PCI device
> pci_raw_set_power_state() doesn't check if the value it wrote into
> the device's PCI_PM_CTRL register has been stored in there, but
> unconditionally modifies the device's current_state field to reflect
> the change.  This may cause problems to happen if the power state of
> the device hasn't been changed in fact, because it will make the PCI
> PM core make a wrong assumption.
> 
> To prevent such situations from happening modify
> pci_raw_set_power_state() so that it reads the device's PCI_PM_CTRL
> register after writing into it and uses the value read from the
> register to update the device's current_state field.  Also make it
> print a message saying that the device refused to change its power
> state as requested (returning an error code in such cases would cause
> suspend regressions to appear on some systems, where device drivers'
> suspend routines return error codes if pci_set_power_state() fails).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
