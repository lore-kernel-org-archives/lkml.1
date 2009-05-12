Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZELOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZELOpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZELOpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:45:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37224 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZELOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iRkAm4IiiJLzNtcR3lAil8t6CRnnhC4NKEabzuyr9ufhh6JIRDTycdcLQxdEVVKeFL
         R5mpfBf8Z+IkmDdGMMayplQ9NtqFXkl0jkov35XLKUUFxIA3cVj9YjSFKGnaPNLatoIK
         Y8ZM7dmGjr3+YpGXWcY/oaKkD/F8A2myOI5yY=
Message-ID: <4A098B8D.10107@panasas.com>
Date: Tue, 12 May 2009 17:45:33 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of blk_update_request
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2009 02:29 PM, FUJITA Tomonori wrote:
> swim3 is the only user of blk_update_request(). Let's use
> blk_end_request instead of blk_update_request. swim3 doesn't need to
> update a request manually. 


> In addition, we can unexport
> blk_update_request().
> 

blk_update_request() was meant for request-based-multi-path, and not for swim3
please see:
    32fab448 block: add request update interface

CC: Kiyoshi Ueda<k-ueda@ct.jp.nec.com>

I think Tejun Heo was just using that in some recent block layer, transformation.
Tejun?

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/block/swim3.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 

Boaz
