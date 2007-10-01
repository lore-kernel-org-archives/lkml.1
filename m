Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXJAUyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXJAUyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJAUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:54:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:3670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXJAUyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:54:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,216,1188802800"; 
   d="scan'208";a="160183867"
Message-ID: <47015E76.6080601@intel.com>
Date: Mon, 01 Oct 2007 13:54:14 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: jesper.juhl@gmail.com
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
 removed from -mm tree
References: <200709290551.l8T5ppNg002621@imap1.linux-foundation.org>
In-Reply-To: <200709290551.l8T5ppNg002621@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2007 20:54:23.0307 (UTC) FILETIME=[3EE301B0:01C8046D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      eepro100: Avoid potential NULL pointer deref in speedo_init_rx_ring()
> has been removed from the -mm tree.  Its filename was
>      eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
> 
> This patch was dropped because an updated version will be merged
> 
> ------------------------------------------------------
> Subject: eepro100: Avoid potential NULL pointer deref in speedo_init_rx_ring()
> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> In a low memory situation, if you are very unlucky, the speedo_init_rx_ring()
> function may cause a NULL pointer deref.
> 
> The problem is in the case where we can't allocate even a single skb for
> the RX ring.  In this case 'last_rxf' will be NULL when we break out of
> the loop and the line
>     last_rxf->status = cpu_to_le32(0xC0000002);	/* '2' is flag value only. */
> will cause a NULL pointer dereference.
> 
> To fix this properly we need to be return an error from speedo_init_rx_ring()
> and have the caller (speedo_open()) catch and propagate the error, as well as
> undo anything done to setup the device so far.
> 
> This patch adds a check to catch the unlucky case of not even a single skb
> being available and adds code in the caller to catch the error and release the
> device properly.
> 
> For a user who hits this problem, this makes the difference between her device
> not being opened and a kernel crash.  Clearly a non functional NIC if
> preferable to a kernel crash - especially since setting up the device can
> easily be retried later after freeing up some memory; a kernel crash is not as
> easy to recover from.
> 
> The problem was initially spotted by the Coverity checker.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


is this actually a problem? everybody should be running e100. I'm surprised to see
a patch for eepro100, just before it gets removed...

Auke
