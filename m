Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZEMA6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZEMA6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZEMA6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:58:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36258 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZEMA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:58:32 -0400
Message-ID: <4A0A1941.2010105@ct.jp.nec.com>
Date: Wed, 13 May 2009 09:50:09 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of blk_update_request
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A098B8D.10107@panasas.com> <4A099562.7020805@kernel.org>
In-Reply-To: <4A099562.7020805@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for pointing this, Boaz!

On 2009/05/13 0:27 +0900, Tejun Heo wrote:
> Hello,
> 
> Boaz Harrosh wrote:
>> blk_update_request() was meant for request-based-multi-path, and not for swim3
>> please see:
>>     32fab448 block: add request update interface
>>
>> CC: Kiyoshi Ueda<k-ueda@ct.jp.nec.com>
>>
>> I think Tejun Heo was just using that in some recent block layer,
>> transformation.
>> Tejun?
> 
> Yeah, conversion was easy that way.  I think it's sane to have
> blk_update_request() exported as long as request internal tinkering is
> kept in block layer proper.

blk_update_request() is needed for request-based dm to keep the request
completion ordering in bottom-up, although request-based dm is not
in upstream yet.

Jens, please keep blk_update_request() exported.

Thanks,
Kiyoshi Ueda

