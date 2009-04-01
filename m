Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbZDAN5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbZDAN5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763790AbZDAN4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:56:49 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12009 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761640AbZDAN4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:56:48 -0400
Message-ID: <49D371FF.3050202@panasas.com>
Date: Wed, 01 Apr 2009 16:54:07 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 15/17] bio/blk-map: kill unused stuff and un-export internal
 functions
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-16-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-16-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 13:56:10.0068 (UTC) FILETIME=[9C859940:01C9B2D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: cleanup, removal of unused / undesirable API
> 
> With recent changes, the following functions aren't used anymore.
> 
> * bio_{map|copy}_{user|kern}()
> * blk_rq_append_bio()
> 

This function is used by drivers/scsi/osd/osd_initiator.c
Currently in mainline. Please use allmodconfig to compile
everything.

> The following functions aren't used outside of block layer.
> 
> * bio_add_pc_page()

And also this

> * bio_un{map|copy}_user()
> 
> Kill the first group and unexport the second.  As bio_add_pc_page() is
> used only inside fs/bio.c, it's made static.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

I've posted propositions on how to fix osd_initiator.c which
involves making blk_map_kern() append to the request, and a new
blk_make_request(bio).

Any suggestions are welcome

Thanks
Boaz
