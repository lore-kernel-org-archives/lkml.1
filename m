Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXDAKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXDAKVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXDAKVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:21:31 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:42066 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbXDAKVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:21:30 -0400
Date: Sun, 1 Apr 2007 13:21:28 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Pedram M <pmessri@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: kswapd issues + kernel 2.4.21-32.0.1.ELsmp
Message-ID: <20070401102127.GA16987@localdomain>
References: <9c9aa5d00703310110s2a21f19l37544c3d46be53c9@mail.gmail.com> <9c9aa5d00703310111w3809fd56t75bcde9d5047ca81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9aa5d00703310111w3809fd56t75bcde9d5047ca81@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 01:11:29AM -0700, Pedram M wrote:
> Hi,
> 
> I've seen this around, and have heard about it in forums and else-where,
> could somebody enlighten me with more information or with experiences
> they have had.  Looks like kswapd begins to eat CPU dramatically till the
> box eventually locks up.

My experience with kswapd eating a lot of CPU tells that this particular 
problem with Linux 2.4 manifests itself on this scenario:

 * No swap is configured (we are blessed with RAM).

_AND_:

 * A lot of memory is allocated (for my case: a lot of anonymous pages 
used for applications).

Looking at this problem with kdb, I noticed that the CPU spends a lot 
of time in swap_out(), even though there are no swap devices...

So...

mm/vmscan.c, replace swap_out with this:

    static int swap_out(zone_t * classzone)
    {
            return 0;
    }

Now, this might raise some eyebrows for those MM gurus reading this
mail but I assure you I've been doing this for a lot of time (and 
a lot of machines) on 2.4.27, and it took care of my kswapd issues
quite nicely.

I hope it helps...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
