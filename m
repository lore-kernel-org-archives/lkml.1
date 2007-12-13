Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXLMWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXLMWDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762638AbXLMWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:02:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933575AbXLMWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:02:48 -0500
Date: Thu, 13 Dec 2007 14:02:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: liml@rtr.ca, lkml@rtr.ca, matthew@wil.cx, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Message-Id: <20071213140207.111f94e2.akpm@linux-foundation.org>
In-Reply-To: <20071213200958.GK10104@kernel.dk>
References: <20071213185326.GQ26334@parisc-linux.org>
	<4761821F.3050602@rtr.ca>
	<20071213192633.GD10104@kernel.dk>
	<4761883A.7050908@rtr.ca>
	<476188C4.9030802@rtr.ca>
	<20071213193937.GG10104@kernel.dk>
	<47618B0B.8020203@rtr.ca>
	<20071213195350.GH10104@kernel.dk>
	<20071213200219.GI10104@kernel.dk>
	<476190BE.9010405@rtr.ca>
	<20071213200958.GK10104@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 21:09:59 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

>
> OK, it's a vm issue,

cc linux-mm and probable culprit.

>  I have tens of thousand "backward" pages after a
> boot - IOW, bvec->bv_page is the page before bvprv->bv_page, not
> reverse. So it looks like that bug got reintroduced.

Bill Irwin fixed this a couple of years back: changed the page allocator so
that it mostly hands out pages in ascending physical-address order.

I guess we broke that, quite possibly in Mel's page allocator rework.

It would help if you could provide us with a simple recipe for
demonstrating this problem, please.

