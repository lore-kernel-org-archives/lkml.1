Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZBDKPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZBDKPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZBDKPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:15:05 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:35437 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbZBDKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:15:04 -0500
From: Frans Pop <elendil@planet.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in pci_legacy_suspend
Date: Wed, 4 Feb 2009 11:14:59 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <200902040154.36018.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl> <1233712613.16867.136.camel@pasglop>
In-reply-To: <1233712613.16867.136.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041115.00842.elendil@planet.nl>
X-OriginalArrivalTime: 04 Feb 2009 10:15:01.0205 (UTC) FILETIME=[7087C850:01C986B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Minor nit: Should the warning be preceeded by a message ? The reason is,
> right now, all we get is a backtrace, it doesn't actually tell you which
> device or driver caused it which makes it pretty pointless.
> 
> I think you should add a printk(KERN_ERR... just before that which gives
> those informations along with a little blurb along the lines of "driver
> changed device state without saving config space state").

That is actually already included in the patch (through drv->suspend):

> -             if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> +             if (pci_dev->current_state != PCI_D0
> +                 && pci_dev->current_state != PCI_UNKNOWN) {
> +                     WARN_ONCE(pci_dev->current_state != prev,
> +                             "PCI PM: Device state not saved by %pF\n",
> +                             drv->suspend);

Cheers,
FJP
