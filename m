Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZCFU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZCFU4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZCFU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:56:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:15980 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbZCFU4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <20090306204623.GJ11787@kernel.dk>
References: <20090228204622.29719.55082.stgit@localhost.localdomain>
	 <fa686aa40903060805i489d8676waad08e8263c02fe@mail.gmail.com>
	 <20090306204623.GJ11787@kernel.dk>
Date: Fri, 6 Mar 2009 13:56:01 -0700
Message-ID: <fa686aa40903061256n35a2f8eck1a6592964daa949b@mail.gmail.com>
Subject: Re: [PATCH] Fix Xilinx SystemACE driver to handle empty CF slot
From: Grant Likely <grant.likely@secretlab.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       John.Linn@xilinx.com, sr@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 1:46 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Mar 06 2009, Grant Likely wrote:
>> > The SystemACE driver does not handle an empty CF slot gracefully.  An
>> > empty CF slot ends up hanging the system.  This patch adds a check for
>> > the CF state and stops trying to process requests if the slot is empty.
>
> So with patches like this, it's always nice to know what your target is.
> Do you want this in .29, or just queued up for .30? It's not always easy
> to judge the urgency of such patches :-)

The driver completely falls down and hangs the system if the CF slot
is empty, so I would like to get it into .29.  On the other hand, it
has been a long standing issue, so if merging it will raise any
eyebrows then I'm okay to wait for .30.

> Also, I note that you are using end_request() throughout the driver. We
> really want to get away from that, you should be using blk_end_request()
> as that will handle full requests and not just segment-by-segment. No
> worries for this patch, but you may want to consider that for a future
> patch.

Okay, will do.

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
