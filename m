Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZF3NIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZF3NIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZF3NIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:08:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58506 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbZF3NIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:08:23 -0400
Date: Tue, 30 Jun 2009 14:09:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090630140945.0784e174@lxorguk.ukuu.org.uk>
In-Reply-To: <200906301448.55064.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	<200906301434.26815.arnd@arndb.de>
	<20090630134000.23674147@lxorguk.ukuu.org.uk>
	<200906301448.55064.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What about non x86 - this is asm-generic you are playing with and its the
> > kind of change that causes evil really hard to track down and subtle
> > corruptions and user data loss if you get it wrong.
> 
> Non-x86 is the real motivation for the patch, because the flush_write_buffers
> call in this file is currently not implemented and causes build errors
> on everything but x86, frv, ia64 and m32r, where the latter two implement
> it as an empty macro.

Ok so the FRV would grow a similar no iommu patch to the x86.

> The only users of the file right now are x86 and ia64, and ia64 only added
> the empty flush_write_buffers() definition in order to use it.

That now all makes sense.
