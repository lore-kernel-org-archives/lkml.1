Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXEOUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXEOUov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXEOUoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:44:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55980 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbXEOUoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:44:44 -0400
Date: Tue, 15 May 2007 22:45:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ppc modprost warnings in 2.6.22-rc1
Message-ID: <20070515204540.GC22966@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0705141717110.23895@math>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0705141717110.23895@math>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 05:20:20PM +0300, Meelis Roos wrote:
> Trying to compile 2.6.22-rc1 for ppc (prep) arch. While section 
> mismatches are an old thing, what are these COMMON symbols?
> 
>   MODPOST vmlinux
> WARNING: "fee_restarts" [arch/ppc/kernel/built-in] is COMMON symbol
> WARNING: "ee_restarts" [arch/ppc/kernel/built-in] is COMMON symbol

Symbols that modpst see belongs to SHN_COMMON.
Should we drop that warning?

> WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x18) and 'Mesquite_pci_IRQ_map'
.....

mot_info is only used by functions marked __init.
So why not mark it __init so it get discarded and we get rid of all those warnings?

	Sam
