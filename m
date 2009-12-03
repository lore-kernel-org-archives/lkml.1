Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZLCI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZLCI3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZLCI3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:29:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:43822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZLCI3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:29:49 -0500
Message-ID: <4B17771B.7050902@kernel.org>
Date: Thu, 03 Dec 2009 17:30:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: michal.simek@petalogix.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 3
References: <20091203180214.16e452ed.sfr@canb.auug.org.au> <4B176B50.4050901@petalogix.com>
In-Reply-To: <4B176B50.4050901@petalogix.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/03/2009 04:40 PM, Michal Simek wrote:
> todays tree is working on MMU microblaze correctly without any visible
> problem but noMMU microblaze kernel still have that bug as I reported
> some days ago.

Other than triggering WARN_ON(), it doesn't cause any other problems,
right?  It's probably because SMP_CACHE_BYTES on that configuration is
lower than 8.  What is the value of SMP_CACHE_BYTES on the
configuration?  Also, doesn't the Linus's tree have the same problem?

The somewhat spurious WARN_ON() in percpu allocator should probably be
just removed or bumped to check against PAGE_SIZE as SMP code does.
The problem is that on UP even though the function takes @align
parameter, it just ignores it.  :-(

Thanks.

-- 
tejun
