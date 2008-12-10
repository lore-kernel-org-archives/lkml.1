Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYLJKR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYLJKR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYLJKRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:17:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38287 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbYLJKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:17:49 -0500
Date: Wed, 10 Dec 2008 10:17:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Yuri Tikhonov <yur@emcraft.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>, Wolfgang Denk <wd@denx.de>,
       Milton Miller <miltonm@bga.com>, Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH] fork_init: fix division by zero
Message-ID: <20081210101745.GG28946@ZenIV.linux.org.uk>
References: <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503391615.20081210130113@emcraft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 01:01:13PM +0300, Yuri Tikhonov wrote:

> >> +     max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
> >                       ^^^^^^^^^^^^^^^^^^^^
> >> +#endif
> 
> > Can't this overflow, e.g. on 32-bit machines with HIGHMEM?
> 
>  The multiplier here is not PAGE_SIZE, but [PAGE_SIZE / (8 * 
> THREAD_SIZE)], and this value is expected to be rather small (2, 4, or 
> so).

x * y / z is parsed as (x * y) / z, not x * (y / z).

Only assignment operators (and ?:, in a sense that a ? b : c ? d : e is
parsed as a ? b : (c ? d : e)) are right-to-left.  The rest is left-to-right.
