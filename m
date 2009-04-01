Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbZDANEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbZDANEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDAND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:03:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:56574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZDAND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:03:57 -0400
Message-ID: <49D3662B.3000801@kernel.org>
Date: Wed, 01 Apr 2009 22:03:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using blk_rq_map_user_iov()
References: <1238583884-13517-9-git-send-email-tj@kernel.org>	<20090401214415W.fujita.tomonori@lab.ntt.co.jp>	<49D36329.20004@kernel.org> <20090401215933S.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401215933S.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:03:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> No, we are not talking about blk_rq_append_bio().
> 
> We are talking about the multiple bio handling in blk_rq_map_user,
> which is the feature that Mike added long time ago. The feature is
> surely necessary for some users. So you can't remote it.

How would someone use that without blk_rq_append_bio()?  The only
reason blk_rq_map_user() had multiple bio chaining was to work around
BIO_MAX_SIZE.  blk_rq_map_user_iov() doesn't support multiple bio
chaining, so sans blk_rq_append_bio() or playing with rq/bio internals
directly, there's no way to use or even know about multiple bios.

Thanks.

-- 
tejun
