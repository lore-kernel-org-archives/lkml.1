Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXKSIW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXKSIW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXKSIWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:22:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:47249 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXKSIWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:22:49 -0500
Subject: Re: [PATCH 2/5] drivers/macintosh/via-pmu.c: Add missing
	pci_dev_put
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711190903100.19198@ask.diku.dk>
References: <Pine.LNX.4.64.0711190903100.19198@ask.diku.dk>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 19:22:39 +1100
Message-Id: <1195460559.7022.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-19 at 09:03 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> There should be a pci_dev_put when breaking out of a loop that iterates
> over calls to pci_get_device and similar functions.
> 
> In this case, the return under the #else case of #ifdef HACKED_PCI_SAVE
> should have a pci_dev_put, just as the return in the case where
> HACKED_PCI_SAVE is true does.
> 
> This was fixed using the following semantic patch.

I think most of that code is no longer necessary (and the lack of
pci_dev_put() is mostly due to the fact that this code long predates the
existence of pci_dev_put :-)

I want to try out without that PCI save/restore code on a couple of old
machines see if we can just remove the whole thing.

Ben.


