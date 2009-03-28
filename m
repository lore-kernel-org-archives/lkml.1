Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZC1Inn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZC1Inn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZC1Ine
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:43:34 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59834 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZC1Inc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=irwz64NHvkgDR7Uw54L5IMyVFTz6idbayUBuT04xXYoHqEgZ2uWLWmWN77rpQWOUS4
         e4Xgo7mftq9m26w8SzNkCNdFtcIqiVSFBxfXry6mv6bxNcjlr28XpU9Clc935rcoRf4U
         1kEBR7WiQvAqv/enY5exaRlaHEnoM2/fbxmvE=
Date: Sat, 28 Mar 2009 09:43:24 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 13/14] ide-atapi: use bio for request sense
Message-ID: <20090328084324.GA1742@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
	linux-ide@vger.kernel.org
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1237910776-10983-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:06:15AM +0900, Tejun Heo wrote:
> Impact: unify request data buffer handling
> 
> rq->data is used mostly to pass kernel buffer through request queue
> without using bio.  There are only a couple of places which still do
> this in kernel and converting to bio isn't difficult.
> 
> This patch converts ide-atapi to use bio instead of rq->data.  For
> ide_queue_pc_tail() which can block, blk_rq_map_kern() is used.  For
> ide_queue_pc_head() which is used for request sense and called from
> atomic context, drive->request_sense_bio and ->request_sense_bvec[2]
> are added and used via bio_map_kern_prealloc().
> 
> ide-tape is updated to map sg for special requests.
> 
> This change makes all ide-atapi commands except for tape bh ones use
> bio.  Drop tp_ops->output/input_data path from ide_pc_intr().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
