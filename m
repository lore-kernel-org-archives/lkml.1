Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXBRRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXBRRIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXBRRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:08:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXBRRIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:08:23 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Which architectures need to sync vmalloc mappings between processes?
Date: Sun, 18 Feb 2007 18:08:13 +0100
User-Agent: KMail/1.9.5
Cc: linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45D7E438.4020902@goop.org>
In-Reply-To: <45D7E438.4020902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181808.13576.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On i386 with PAE, this is not necessary because the kernel's mappings
> are shared between all processes anyway, so it would be a no-op.  
> However, non-PAE i386 has a separate kernel mapping for each process,
> and so needs to sync them - typically lazily on faults, but
> vmalloc_sync_all exists to allow mass syncing when required.

The only case that needs it right now on x86 is NMI handlers in modules
to avoid early IRETs that could cause NMI recursion.

That's a very obscure architecture specific quirk and I wouldn't expect any 
other architecture to suffer from this.

-Andi
