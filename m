Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbXHHJ4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbXHHJ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXHHJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:55:50 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34353 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXHHJzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:55:49 -0400
Date: Wed, 8 Aug 2007 13:54:49 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel Phillips <phillips@phunq.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Block device throttling [Re: Distributed storage.]
Message-ID: <20070808095448.GA3440@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708051423.45484.phillips@phunq.net> <20070807120523.GX5245@kernel.dk> <200708071124.56859.phillips@phunq.net> <20070807205538.GB5245@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807205538.GB5245@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:55:38PM +0200, Jens Axboe (jens.axboe@oracle.com) wrote:
> I don't like structure bloat, but I do like nice design. Overloading is

So, what did we decide? To bloat bio a bit (add a queue pointer) or to
use physical device limits? The latter requires to replace all occurence
of bio->bi_bdev = something_new with blk_set_bdev(bio, somthing_new),
where queue limits will be appropriately charged. So far I'm testing
second case, but I only changed DST for testing, can change all other
users if needed though.

-- 
	Evgeniy Polyakov
