Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZBIBGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZBIBGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZBIBGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:06:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbZBIBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:06:12 -0500
Date: Sun, 08 Feb 2009 17:06:05 -0800 (PST)
Message-Id: <20090208.170605.01154488.davem@davemloft.net>
To: alex.williamson@hp.com
Cc: maxk@qualcomm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tun: Fix unicast filter overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090207174404.16716.20574.stgit@kvm.aw>
References: <20090207174404.16716.20574.stgit@kvm.aw>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@hp.com>
Date: Sat, 07 Feb 2009 10:45:13 -0700

> Tap devices can make use of a small MAC filter set via the
> TUNSETTXFILTER ioctl.  The filter has a set of exact matches
> plus a hash for imperfect filtering of additional multicast
> addresses.  The current code is unbalanced, adding unicast
> addresses to the multicast hash, but only checking the hash
> against multicast addresses.  This results in the filter
> dropping unicast addresses that overflow the exact filter.
> The fix is simply to disable the filter by leaving count set
> to zero if we find non-multicast addresses after the exact
> match table is filled.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

Doesn't it make more sense to remove the multicast check
in the filter check function?

With your change, the user gets absolutely no indication
that filtering has been completely disabled simply because
they put too many unicast addresses into the filter.  We
just return zero, that's crazy.
