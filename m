Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZBSRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZBSRxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZBSRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:53:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48634 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZBSRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:53:05 -0500
X-IronPort-AV: E=Sophos;i="4.38,236,1233550800"; 
   d="scan'208";a="40450099"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18845.40059.190188.291643@mariner.uk.xensource.com>
Date: Thu, 19 Feb 2009 17:52:59 +0000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Anders Kaseorg <andersk@MIT.EDU>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] IRQ handling race and spurious IIR read in serial/8250.c
In-Reply-To: <18834.63479.700909.321686@mariner.uk.xensource.com>
References: <1233800599.5398.0.camel@balanced-tree>
	<18827.7191.646173.99255@mariner.uk.xensource.com>
	<1233862446.5676.28.camel@balanced-tree>
	<1233870772.5676.40.camel@balanced-tree>
	<18833.40557.119090.48930@mariner.uk.xensource.com>
	<alpine.DEB.2.00.0902101249181.20723@vinegar-pot.mit.edu>
	<18834.63479.700909.321686@mariner.uk.xensource.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
X-OriginalArrivalTime: 19 Feb 2009 17:53:02.0098 (UTC) FILETIME=[E89D8720:01C992BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> In drivers/serial/8250.c in Linux there are two bugs:
>  1. UART_BUG_TXEN can be spuriously set, due to an IRQ race
>  2. The workaround then applied by the kernel is itself buggy

Markus Armbruster has also experienced this problem in a Xen
environment and has confirmed that my patch fixes it.

I think at the very least this change:

> Proposed initial band-aid fix (against 2.6.28.4):
> 
> Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
> 
> Reading the IIR clears some oustanding interrupts so it is not safe.
> Instead, simply transmit immediately if the buffer is empty without
> regard to IIR.
> 
> Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>

should be made right away.

Ian.
