Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXIYPLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXIYPLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXIYPLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:11:30 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:51288 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbXIYPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:11:29 -0400
Date: Tue, 25 Sep 2007 10:11:12 -0500
From: Scott Wood <scottwood@freescale.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
Message-ID: <20070925151112.GB15739@ld0162-tx32.am.freescale.net>
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com> <46F7EE95.1040509@scram.de> <46F80049.2030509@freescale.com> <46F8FA5F.3050907@scram.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F8FA5F.3050907@scram.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 02:09:03PM +0200, Jochen Friedrich wrote:
> In cpm_uart_core.c, the operation "pinfo->rx_bd_base - DPRAM_BASE" is 
> used to calculate the DPRAM offset. So DPRAM_BASE must be relative to 
> dpram_vbase in commproc.c as well. However, cpm_uart_cpm1.h uses cpmp in 
> commproc.c to initialize DPRAM_BASE.
> 
> On ARCH=ppc, cpmp is a physical address with 1:1 virtual mapping ("well 
> known address"). On ARC=powerpc, this is an address obtained by 
> ioremap(), however it's a different ioremap() call than dpram_vbase is 
> obtained from, so noone can guarantee
> cpmp is always the same as dpram_vbase even on ARCH=powerpc.

I have patches submitted in which they're from the same ioremap, but
I agree that using cpm_dpram_addr(0) is a more robust way.

-Scott
