Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZBDBZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZBDBZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZBDBZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:25:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZBDBZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:25:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Wed, 4 Feb 2009 02:25:21 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902031833.12777.elendil@planet.nl> <200902031842.44186.elendil@planet.nl>
In-Reply-To: <200902031842.44186.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040225.22113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Frans Pop wrote:
> On Tuesday 03 February 2009, Frans Pop wrote:
> > Looking at iwl-agn.c the cause could be that iwl_pci_suspend() depends
> > on iwl_mac_stop() to call pci_save_state(). I added some debug
> > statements in iwl_pci_suspend() that showed priv->is_open is false, so
> > iwl_mac_stop does indeed *not* get called when the interface is down.
> 
> However, iwl_mac_stop() had been called when I ran ifdown just before
> suspending the system:

The problem that the warning can be triggered by a device being in a low
power state already before suspend should be fixed by the PCI PM fixes I've
just posted.

Thanks,
Rafael
