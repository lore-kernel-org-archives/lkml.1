Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbYBKRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbYBKRgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbYBKRgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:36:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838AbYBKRgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:36:07 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [1/1] CPA: Flush the caches when setting pages not present v2
Date: Mon, 11 Feb 2008 18:36:03 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080211216.571751871@suse.de> <alpine.LFD.1.00.0802111803290.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802111803290.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111836.03195.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is suboptimal though, as it will trigger a wbinvd() everytime
> when we hit a non present pte in a range, whether we did set the entry
> in question to not present or not.

Do you think that's common? I considered this while writing the code,
but figured it was just a oddball case not worth caring about.

DEBUG_PAGEALLOC does not call this normally anyways and people
should not call this for unallocated mappings anyways. 

> The gart code unmapping is a special case. This only happens during
> boot, so adding a wbinvd() to the gart code is solving this issue
> without imposing it on other use cases.
> 
> Another solution for this would be to change the mapping to uncached
> before unmapping, so we could avoid the wbinvd() completely.

That will work for pci-gart, but not for some future users of set_memory_np()
I plan to submit (they run potentially with multiple CPUs online and doing callbacks
there would be quite ugly). So I would prefer  if you kept some variant of my original patch.

-Andi

