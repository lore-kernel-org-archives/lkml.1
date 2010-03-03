Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0CCPrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:45 -0500
Received: from ns1.coraid.com ([12.51.113.4]:46168 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752335Ab0CCPrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:14 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 10:47:14 EST
Date: Wed, 3 Mar 2010 10:30:15 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, taeuber@bbaw.de
Subject: Re: aoeblk_make_request() chokes on zero-length barriers
Message-ID: <20100303153015.GD3268@coraid.com>
References: <4B8DE160.5070506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8DE160.5070506@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:11:12PM +0900, Tejun Heo wrote:
> Hello, Ed L. Cashin.
> 
> This is reported on openSUSE 11.2 by Lars Tauber on bnc581271[1] but
> upstream code seems to have the same problem.  If a bio doesn't have
> bi_io_vec, aoeblk_make_request() triggers BUG() but in recent kernels
> the block layer will happily send down zero-length barrier bios w/o
> bi_io_vec set.

It looks like the opensuse 11.x kernel doesn't have the
change that made aoe return -EOPNOTSUPP for barriers.

It's commit 18d8217bc441630c3c5ec7416c5a65c69e8a0979,
appearing in v2.6.32-rc1.

I have most of a barrier implementation for aoe done
but got sidetracked.  I'd welcome any volunteers who
would like to do testing.  Please email me directly.

-- 
  Ed Cashin <ecashin@coraid.com>
