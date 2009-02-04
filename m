Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZBDVxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZBDVxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZBDVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:53:24 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:13087 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbZBDVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:53:24 -0500
From: Frans Pop <elendil@planet.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in pci_legacy_suspend
Date: Wed, 4 Feb 2009 22:53:15 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <200902040154.36018.rjw@sisk.pl> <200902041115.00842.elendil@planet.nl> <1233783502.4612.7.camel@pasglop>
In-Reply-To: <1233783502.4612.7.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042253.17447.elendil@planet.nl>
X-OriginalArrivalTime: 04 Feb 2009 21:53:18.0286 (UTC) FILETIME=[FD22FEE0:01C98712]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 11:14 +0100, Frans Pop wrote:
> > Benjamin Herrenschmidt wrote:
> > > Minor nit: Should the warning be preceeded by a message ? The
> > > reason is, right now, all we get is a backtrace, it doesn't
> > > actually tell you which device or driver caused it which makes it
> > > pretty pointless.
> > >
> > > I think you should add a printk(KERN_ERR... just before that which
> > > gives those informations along with a little blurb along the lines
> > > of "driver changed device state without saving config space
> > > state").
> >
> > That is actually already included in the patch (through
> > drv->suspend):
>
> How so ? I've had such backtraces with no other info in my log...

Previous versions did not have the info, but with this patch I get:
WARNING: at drivers/pci/pci-driver.c:374 pci_legacy_suspend+0x9b/0xde()
Hardware name: HP Compaq 2510p Notebook PC
PCI PM: Device state not saved by iwl_pci_suspend+0x0/0x4c [iwlagn]
[...]

Driver and function causing the warning are in the last line.

Cheers,
FJP
