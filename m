Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZAVFQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZAVFQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZAVFQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:16:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:53902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZAVFQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:16:25 -0500
Subject: Re: 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisl.pl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0901212045370.26621@blonde.anvils>
References: <Pine.LNX.4.64.0901212045370.26621@blonde.anvils>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 16:16:10 +1100
Message-Id: <1232601370.23611.98.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's as far as I took it: I can see there's code to set up
> "Legacy VGA memory" but it looks like that's not coming into play.
> dmesg and .config attached: I think you'll get to the point much
> quicker than I would.
> 
> Though I bet you're busy at the moment: no hurry, I can comment
> out the pci_create_legacy_files() from drivers/pci/bus.c for now.

It's actually an X bug :-(

IE, I always create the legacy files, I just make mmap fail when legacy
VGA isn't available. This is the right way to do it, as it properly
informs X that yes, I do support the new API and no, there's no point in
trying to access legacy VGA memory on this machine.

I honestly don't see how I can fix that without making proper support
for legacy memory / IO impossible, and thus guaranteeing that X will
eternally continue to crap on random bits of /dev/mem in the future :-(

Cheers,
Ben.


