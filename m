Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZEHGkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZEHGkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZEHGk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:40:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZEHGk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:40:27 -0400
Date: Fri, 8 May 2009 08:45:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508064517.GX23223@one.firstfloor.org>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 11:47:09AM +0800, Shaohua Li wrote:
> lockdep report below warning when I try to offline one cpu:
> [  110.835487] =================================
> [  110.835616] [ INFO: inconsistent lock state ]
> [  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
> [  110.835757] ---------------------------------
> [  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b
> 
> smp_call_function_single() will disable interrupt. moving mce reenable/disable
> to workqueue, so no irq is disabled.

Looks good. Thanks.

Acked-by: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>

-Andi
