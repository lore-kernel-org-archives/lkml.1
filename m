Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbZELLdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbZELLdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbZELLcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:32:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:49851 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760619AbZELLck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:32:40 -0400
Date: Tue, 12 May 2009 20:31:31 +0900
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH block#for-2.6.31] scsi: fix resid_len mis-conversion in
 scsi_end_request()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A08DBBA.1000208@kernel.org>
References: <4A08DBBA.1000208@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090512131038A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 20:31:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 11:15:22 +0900
Tejun Heo <tj@kernel.org> wrote:

> Commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f introduced
> rq->data_len and converted residual count users to it.  While
> converting, it mistakenly converted scsi_end_request() to finish
> requests with residual count when it wants to do is fully complete the
> request.  Fix it by using blk_end_request_all() instead.
> 
> This bug was spotted by Boaz Harrosh.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Spotted-by: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi_lib.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Looks good to me.
