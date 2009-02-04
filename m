Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZBDMRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZBDMRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBDMR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:17:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZBDMRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:17:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Wed, 4 Feb 2009 13:17:08 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902040225.22113.rjw@sisk.pl> <200902041258.53669.elendil@planet.nl>
In-Reply-To: <200902041258.53669.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041317.08408.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Frans Pop wrote:
> On Wednesday 04 February 2009, Rafael J. Wysocki wrote:
> > On Tuesday 03 February 2009, Frans Pop wrote:
> > > On Tuesday 03 February 2009, Frans Pop wrote:
> > > > Looking at iwl-agn.c the cause could be that iwl_pci_suspend()
> > > > depends on iwl_mac_stop() to call pci_save_state(). I added some
> > > > debug statements in iwl_pci_suspend() that showed priv->is_open is
> > > > false, so iwl_mac_stop does indeed *not* get called when the
> > > > interface is down.
> > >
> > > However, iwl_mac_stop() had been called when I ran ifdown just before
> > > suspending the system:
> >
> > The problem that the warning can be triggered by a device being in a
> > low power state already before suspend should be fixed by the PCI PM
> > fixes I've just posted.
> 
> I'm afraid I still get the warning with your latest patches on top of 
> v2.6.29-rc3-495-gdcf6a79.

If you're still getting the warning with these patches, then yes, the problem
appears to be in iwl-agn.c .
 
> IIUC the device is not yet in low power state when I suspend, but only 
> disabled. The subject of the mail proved to be incorrect, sorry.
> 
> Please take a look at the functions from iwl-agn.c mentioned above. I 
> think the problem is there.

I will.

Thanks,
Rafael
