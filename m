Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZH3M6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZH3M6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZH3M6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:58:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37085 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZH3M6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RlIFT5DrkOh0GeW2NjbaB9Qf2HJfJ5iRCq7oLjvJGVDqxCm7qG2H64liWY0puHKuU0
         EJIL6fKOfml3FzGy1Tz1jrgFRbdJHb03PJYQwxf3z5H72MKsYCWSOTF6ihOQsrUr432i
         QZOFAMUwnDhyH1vo/igYYl8OSr76C3PoQmtI4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw2200: firmware DMA loading rework
Date: Sun, 30 Aug 2009 14:37:42 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@skynet.ie>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <20090826074409.606b5124.akpm@linux-foundation.org> <1251430951.3704.181.camel@debian>
In-Reply-To: <1251430951.3704.181.camel@debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908301437.42133.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009 05:42:31 Zhu Yi wrote:
> Bartlomiej Zolnierkiewicz reported an atomic order-6 allocation failure
> for ipw2200 firmware loading in kernel 2.6.30. High order allocation is

s/2.6.30/2.6.31-rc6/

The issue has always been there but it was some recent change that
explicitly triggered the allocation failures (after 2.6.31-rc1).

> likely to fail and should always be avoided.
> 
> The patch fixes this problem by replacing the original order-6
> pci_alloc_consistent() with an array of order-1 pages from a pci pool.
> This utilized the ipw2200 DMA command blocks (up to 64 slots). The
> maximum firmware size support remains the same (64*8K).
> 
> This patch fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14016
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Thanks for the fix (also kudos to other people helping with the bugreport),
it works fine so far and looks OK to me:

Tested-and-reviewed-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
