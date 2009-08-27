Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZH0JWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZH0JWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZH0JWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:22:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52064 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZH0JWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:22:14 -0400
To: richard@rsk.demon.co.uk
CC: miklos@szeredi.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
In-reply-to: <1251306319.2290.6.camel@castor> (message from Richard Kennedy on
	Wed, 26 Aug 2009 18:05:19 +0100)
Subject: Re: [RFC PATCH] mm: balance_dirty_pages. reduce calls to
 global_page_state to reduce cache references
References: <1250855961.2226.94.camel@castor>
	 <1250863494.7538.49.camel@twins>  <E1MfuU8-00088Q-Ta@pomaz-ex.szeredi.hu> <1251306319.2290.6.camel@castor>
Message-Id: <E1MgbB6-0003fp-BU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Aug 2009 11:21:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Richard Kennedy wrote:
> The old behavior was to use NR_WRITEBACK_TEMP to clip the bdi
> thresholds.

Right.

> Should we continue to do this or just ignore NR_WRIEBACK_TEMP completely
> in balance_dirty_pages ?

I think we should.  Using NR_WRIEBACK_TEMP for setting up per-bdi
thresholds should be OK.  It limits the total number of writback pages
(including fuse ones) but doesn't prevent individual bdi's from
continuing writback at their own pace.

Thanks,
Miklos
