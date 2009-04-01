Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbZDANMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbZDANMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZDANMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:12:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:60219 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZDANME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:12:04 -0400
Date: Wed, 1 Apr 2009 22:10:53 +0900
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using
 blk_rq_map_user_iov()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D3662B.3000801@kernel.org>
References: <49D36329.20004@kernel.org>
	<20090401215933S.fujita.tomonori@lab.ntt.co.jp>
	<49D3662B.3000801@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401221102O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 22:10:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 22:03:39 +0900
Tejun Heo <tj@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > No, we are not talking about blk_rq_append_bio().
> > 
> > We are talking about the multiple bio handling in blk_rq_map_user,
> > which is the feature that Mike added long time ago. The feature is
> > surely necessary for some users. So you can't remote it.
> 
> How would someone use that without blk_rq_append_bio()?  The only

Hmm, I'm not sure what you are talking about.

Why do we need to live without blk_rq_append_bio()?

You want to remove blk_rq_append_bio()? Please make your goal clear.


> reason blk_rq_map_user() had multiple bio chaining was to work around
> BIO_MAX_SIZE.  blk_rq_map_user_iov() doesn't support multiple bio
> chaining, so sans blk_rq_append_bio() or playing with rq/bio internals
> directly, there's no way to use or even know about multiple bios.

Yes, only non iovec interface of SG_IO supports large data
transfer. Users have been lived with that.
