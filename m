Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYLJVrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYLJVrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYLJVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:46:56 -0500
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:21672 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbYLJVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:46:56 -0500
From: Frans Pop <elendil@planet.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
Date: Wed, 10 Dec 2008 22:46:51 +0100
User-Agent: KMail/1.9.9
Cc: Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200812061316.38460.elendil@planet.nl> <200812101424.42755.elendil@planet.nl> <49402CBD.9020706@s5r6.in-berlin.de>
In-Reply-To: <49402CBD.9020706@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812102246.52798.elendil@planet.nl>
X-OriginalArrivalTime: 10 Dec 2008 21:46:53.0202 (UTC) FILETIME=[D079D720:01C95B10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008, Stefan Richter wrote:
> Frans Pop wrote:
> > Any suggestions how to try and trace if that's what's happening?
>
> Test after booting with the kernel parameter nomsi.

With pci=nomsi I still get the same "irq 19: nobody cared".

The devices that normally get MSI now get assigned as follows:
- pcieport-driver: IRQ 16 and 17
- iwlagn: irq 17
- e1000e: irq 22

ohci1394 remains the only driver at irq 19.

Except for the changes due to the nomsi option I see no significant 
changes in dmesg for boot plus one suspend/resume cycle.
