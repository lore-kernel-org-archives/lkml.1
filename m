Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZDHGq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZDHGq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZDHGqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:46:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47063 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZDHGqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:46:46 -0400
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 1/2] Avoid putting a bad page back on the LRU
From: Andi Kleen <andi@firstfloor.org>
References: <20090408001133.GB27170@sgi.com>
	<200904080543.16454.ioe-lkml@rameria.de>
Date: Wed, 08 Apr 2009 08:46:41 +0200
In-Reply-To: <200904080543.16454.ioe-lkml@rameria.de> (Ingo Oeser's message of "Wed, 8 Apr 2009 05:43:15 +0200")
Message-ID: <87r603abhq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser <ioe-lkml@rameria.de> writes:
>
> Clearing the flag doesn't change the fact, that this page is representing 
> permanently bad RAM.

Yes, you cannot ever clear a Poison flag, at least not without a special
hardware mechanism that clears the hardware poison too (but that has
other issues in Linux too). Otherwise you would die later.

> What about removing it from the LRU and adding it to a bad RAM list in every case?

That is what memory_failure() already should be doing. Except there's no list
currently.

> After hot swapping the physical RAM banks it could be moved back, not before.

Linux doesn't really support that. That is at least not when it's OS visible.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
