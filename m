Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXHVMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXHVMrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXHVMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:47:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758375AbXHVMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:47:39 -0400
Date: Wed, 22 Aug 2007 14:47:37 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Jeffrey W. Baker" <jwbaker@acm.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: huge improvement with per-device dirty throttling
Message-ID: <20070822124736.GQ13915@v2.random>
References: <1187764638.6869.17.camel@hannibal> <p733aybzv6e.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p733aybzv6e.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 01:05:13PM +0200, Andi Kleen wrote:
> Ok perhaps the new adaptive dirty limits helps your single disk
> a lot too. But your improvements seem to be more "collateral damage" @)
> 
> But if that was true it might be enough to just change the dirty limits
> to get the same effect on your system. You might want to play with
> /proc/sys/vm/dirty_*

The adaptive dirty limit is per task so it can't be reproduced with
global sysctl. It made quite some difference when I researched into it
in function of time. This isn't in function of time but it certainly
makes a lot of difference too, actually it's the most important part
of the patchset for most people, the rest is for the corner cases that
aren't handled right currently (writing to a slow device with
writeback cache has always been hanging the whole thing).
