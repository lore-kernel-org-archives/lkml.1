Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZIRUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZIRUas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZIRUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZIRUan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:30:43 -0400
Date: Fri, 18 Sep 2009 16:30:40 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Message-ID: <20090918203040.GA6031@redhat.com>
References: <4AB3B43D.9000802@ce.jp.nec.com> <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009 at  3:28pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> +	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> +		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> 
> I'm really not keen on perpetuating SAFE_MAX_SECTORS for something that
> was written in this millennium.
> 
> I'd much rather we just do this, then:
> 
> block: Set max_sectors correctly for stacking devices
> 
> The topology changes unintentionally caused SAFE_MAX_SECTORS to be set
> for stacking devices.  Set the default limit to BLK_DEF_MAX_SECTORS and
> provide SAFE_MAX_SECTORS in blk_queue_make_request() for legacy hw
> drivers that depend on the old behavior.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Nice.  Avoids the need for a safe queue_limits copy and associated naunce.

Acked-by: Mike Snitzer <snitzer@redhat.com>
