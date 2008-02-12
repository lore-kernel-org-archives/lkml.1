Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbYBLRmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbYBLRmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763349AbYBLRm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:42:27 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:43580 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbYBLRm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:42:26 -0500
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: multiple drivers, single device
X-Message-Flag: Warning: May contain useful information
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org>
	<20080212164232.GA326@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 09:42:20 -0800
In-Reply-To: <20080212164232.GA326@kroah.com> (Greg KH's message of "Tue, 12 Feb 2008 08:42:32 -0800")
Message-ID: <adak5lavzpf.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Feb 2008 17:42:23.0297 (UTC) FILETIME=[9FC77B10:01C86D9E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The work I'm doing here is for stupid PCI firmware engineers, who have
 > created devices that are different things, all bound up under the same
 > PCI device.  I'm thinking of watchdog timers and random number
 > generator and i2c controller on the same PCI device, or even the more
 > basic, frame buffer and DRM access to the same PCI video device.
 > 
 > The OLPC is a good example of hardware that needs this kind of
 > functionality.

Sounds interesting.  I've been meaning to work on this too for quite a
while, but I'm glad to see you beat me to it.

An example of an in-tree use case for this would be the mlx4 drivers--
you can look at drivers/net/mlx4/intf.c to see the simple stupid
solution I came up with to allow an IB and a NIC (not yet upstream)
driver to share the same PCI device.  A good test for your stuff would
be if it simplifies the code from the ad hoc solution I came up with.

 - R.
