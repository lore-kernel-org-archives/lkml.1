Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbZBNAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbZBNAso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBNAsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:48:36 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:44702 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbZBNAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:48:35 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Sat, 14 Feb 2009 01:48:32 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902041258.53669.elendil@planet.nl> <200902041317.08408.rjw@sisk.pl>
In-Reply-To: <200902041317.08408.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140148.32740.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2009 00:48:33.0913 (UTC) FILETIME=[F6A81690:01C98E3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Rafael J. Wysocki wrote:
> On Wednesday 04 February 2009, Frans Pop wrote:
> > On Wednesday 04 February 2009, Rafael J. Wysocki wrote:
> > > On Tuesday 03 February 2009, Frans Pop wrote:
> > > > On Tuesday 03 February 2009, Frans Pop wrote:
> > > > > Looking at iwl-agn.c the cause could be that iwl_pci_suspend()
> > > > > depends on iwl_mac_stop() to call pci_save_state(). I added
> > > > > some debug statements in iwl_pci_suspend() that showed
> > > > > priv->is_open is false, so iwl_mac_stop does indeed *not* get
> > > > > called when the interface is down.
> > > >
> > > > However, iwl_mac_stop() had been called when I ran ifdown just
> > > > before suspending the system:
> > >
> > > The problem that the warning can be triggered by a device being in
> > > a low power state already before suspend should be fixed by the PCI
> > > PM fixes I've just posted.
> >
> > I'm afraid I still get the warning with your latest patches on top of
> > v2.6.29-rc3-495-gdcf6a79.
>
> If you're still getting the warning with these patches, then yes, the
> problem appears to be in iwl-agn.c .

FYI, this looks to be fixed in -rc5 by c4e061ace755 + 89c581b3fb29.

Thanks,
FJP
