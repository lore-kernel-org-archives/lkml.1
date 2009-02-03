Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZBCOmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZBCOmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZBCOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:41:57 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:22982 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbZBCOl4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:41:56 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Comparison between .28 and .29-rc3 for STR cycle
Date: Tue, 3 Feb 2009 15:41:49 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <200902031237.53579.elendil@planet.nl>
In-Reply-To: <200902031237.53579.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902031541.50182.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 14:41:51.0001 (UTC) FILETIME=[8CB30890:01C9860D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Frans Pop wrote:
> # Of the next 4 lines only the 3rd line also appears during normal
> boot.
>  +pci 0000:00:02.0: PME# disabled 
>  +pci 0000:00:02.1: PME# disabled
>  +pci 0000:00:03.0: PME# disabled
>  +pci 0000:00:03.2: PME# disabled

The 3rd device is also the only one that has a "PME# supported" line 
during normal boot.

Problem seems to be in drivers/pci/pci.c in pci_enable_wake(), which has:
        if (!enable || pci_pme_capable(dev, state)) {
                pci_pme_active(dev, enable);
                pme_done = true;
        }

So it's always called if enable is false, regardless of whether the device 
is PME# capable. Should a test for dev->pme_support be added somewhere?

It seems harmless, just inconsistent.
