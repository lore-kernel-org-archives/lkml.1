Return-Path: <linux-kernel-owner+w=401wt.eu-S1763189AbYF3SET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763189AbYF3SET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763312AbYF3SDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:03:53 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:45319 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763307AbYF3SDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:03:53 -0400
Message-ID: <48692008.3010003@oracle.com>
Date: Mon, 30 Jun 2008 11:03:52 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: use cmpxchg in aio_read_evt() instead of aio_ring_info->ring_lock
References: <200806260932.53563.knikanth@suse.de>
In-Reply-To: <200806260932.53563.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan wrote:
> Use cmpxchg in aio_read_evt() and remove the aio_ring_info->ring_lock

I don't think this is safe because the cmpxhg() can't differentiate the
0 it read at one point with a 0 that it reads in the future after other
racing threads have done enough work on the ring index to wrap it.

- z
