Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbZDANSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbZDANSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDANSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:18:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:36521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZDANSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:18:43 -0400
Message-ID: <49D3699F.4030105@kernel.org>
Date: Wed, 01 Apr 2009 22:18:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using blk_rq_map_user_iov()
References: <49D36329.20004@kernel.org>	<20090401215933S.fujita.tomonori@lab.ntt.co.jp>	<49D3662B.3000801@kernel.org> <20090401221102O.fujita.tomonori@lab.ntt.co.jp> <49D36951.9000604@kernel.org>
In-Reply-To: <49D36951.9000604@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:18:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>>> reason blk_rq_map_user() had multiple bio chaining was to work around
>>> BIO_MAX_SIZE.  blk_rq_map_user_iov() doesn't support multiple bio
>>> chaining, so sans blk_rq_append_bio() or playing with rq/bio internals
>>> directly, there's no way to use or even know about multiple bios.
>> Yes, only non iovec interface of SG_IO supports large data
>> transfer. Users have been lived with that.
> 
> This patch doesn't remove any feature.  You don't lose anything.  What
> used to be done with multiple bios is now done with single bio.  The
> implementation is simpler and shorter.  Using or not using multiple
> bios doesn't (and shouldn't) make any difference to blk_map_*() users.

Oh.. and blk_rq_map_user_iov() now gets to play with large requests
too.  :-)

-- 
tejun
