Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZBCRd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZBCRd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZBCRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:33:17 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:30021 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZBCRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:33:16 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Tue, 3 Feb 2009 18:33:12 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl> <200902031034.12175.rjw@sisk.pl>
In-Reply-To: <200902031034.12175.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902031833.12777.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 17:33:13.0201 (UTC) FILETIME=[7D5E3E10:01C98625]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, you wrote:
> On Tuesday 03 February 2009, Frans Pop wrote:
> > This is the second time I've hit this warning on an STR. Most times
> > I do *not* get the warning. The first line is an extra debug printk I
> > added after the first occurrence to give me the driver causing the
> > problem.
> >
> > What is different is that before this suspend I had switched to my
> > wired e1000e NIC and had done an ifdown on the wireless. I suspect
> > that because of that the wireless already was at D3 _before_ the
> > suspend was started.

The warning is reproducible if wlan0 is down during suspend.

> If ifdown causes the device to go into D3, then this is possible.

I've done some extra checking and if I read it correctly lspci -vvv lists
the status as D0 after ifdown, so that's probably not it. I've also added
extra info in the warning and at that time the status is D3hot.

Looking at iwl-agn.c the cause could be that iwl_pci_suspend() depends on
iwl_mac_stop() to call pci_save_state(). I added some debug statements in 
iwl_pci_suspend() that showed priv->is_open is false, so iwl_mac_stop 
does indeed *not* get called when the interface is down.

Is that it? Not sure what the correct fix would be if it is.

Cheers,
FJP
