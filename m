Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZBDL7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZBDL7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZBDL65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:58:57 -0500
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:37378 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZBDL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:58:56 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Wed, 4 Feb 2009 12:58:52 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902031842.44186.elendil@planet.nl> <200902040225.22113.rjw@sisk.pl>
In-Reply-To: <200902040225.22113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041258.53669.elendil@planet.nl>
X-OriginalArrivalTime: 04 Feb 2009 11:58:54.0272 (UTC) FILETIME=[F3BA5400:01C986BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Rafael J. Wysocki wrote:
> On Tuesday 03 February 2009, Frans Pop wrote:
> > On Tuesday 03 February 2009, Frans Pop wrote:
> > > Looking at iwl-agn.c the cause could be that iwl_pci_suspend()
> > > depends on iwl_mac_stop() to call pci_save_state(). I added some
> > > debug statements in iwl_pci_suspend() that showed priv->is_open is
> > > false, so iwl_mac_stop does indeed *not* get called when the
> > > interface is down.
> >
> > However, iwl_mac_stop() had been called when I ran ifdown just before
> > suspending the system:
>
> The problem that the warning can be triggered by a device being in a
> low power state already before suspend should be fixed by the PCI PM
> fixes I've just posted.

I'm afraid I still get the warning with your latest patches on top of 
v2.6.29-rc3-495-gdcf6a79.

IIUC the device is not yet in low power state when I suspend, but only 
disabled. The subject of the mail proved to be incorrect, sorry.

Please take a look at the functions from iwl-agn.c mentioned above. I 
think the problem is there.

Cheers,
FJP
