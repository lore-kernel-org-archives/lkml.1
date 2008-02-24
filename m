Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYBXT1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYBXT1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYBXT1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:27:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:58697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYBXT1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:27:45 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
Date: Sun, 24 Feb 2008 20:27:36 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
References: <20080224174605.GA21661@mailshack.com>
In-Reply-To: <20080224174605.GA21661@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802242027.36591.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008 18:46:05 Alexander van Heukelum wrote:
> Hi Andi,
> 
> My eyes fell on the following table in the boot messages:
> 
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-374557] TEXT DATA BSS
> early res: 3 [9fc00-a0bff] EBDA
> early res: 4 [8000-afff] PGTABLE
> 
> The memory reserved for the EBDA overflows into the area normally
> reserved for the VGA adaptor. It seems that you wanted to force
> the allocation to cover whole pages, like:
> 
> early res: 3 [9f000-9ffff] EBDA
> 
> This is what this patch implements.

Thanks.
 
> Is it really necessary to force the allocation to a page boundary?

In theory not, in practice it works around some problems in early
allocations where the other users assume page alignment.
At some point it needs to be cleaned up properly.

-Andi
