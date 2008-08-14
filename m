Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYHNH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYHNH6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 03:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHNH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 03:58:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYHNH6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 03:58:09 -0400
Date: Thu, 14 Aug 2008 09:58:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       ?????? ?????? <yoshikawa.takuya@oss.ntt.co.jp>, dpshah@google.com
Subject: Re: [PATCH] virtio_blk: use a wrapper function to access io context  information of IO requests
Message-ID: <20080814075802.GI20055@kernel.dk>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp> <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp> <1218615271.16667.38.camel@sebastian.kern.oss.ntt.co.jp> <200808141442.09633.rusty@rustcorp.com.au> <1218691031.31285.20.camel@sebastian.kern.oss.ntt.co.jp> <1218691323.31285.31.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1218691323.31285.31.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14 2008, Fernando Luis Vázquez Cao wrote:
> struct request has an ioprio member but it is never updated because
> currently bios do not hold io context information. The implication of
> this is that virtio_blk ends up passing useless information to the
> backend driver.
> 
> That said, some IO schedulers such as CFQ do store io context
> information in struct request, but use private members for that, which
> means that that information cannot be directly accessed in a IO
> scheduler-independent way.
> 
> This patch adds a function to obtain the ioprio of a request. We should
> avoid accessing ioprio directly and use this function instead, so that
> its users do not have to care about future changes in block layer
> structures or what the currently active IO controller is.
> 
> This patch does not introduce any functional changes but paves the way
> for future clean-ups and enhancements.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Fine with me, applied.

-- 
Jens Axboe

