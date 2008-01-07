Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYAGGiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYAGGiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 01:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYAGGh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 01:37:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:51818 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbYAGGhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WdxSSDKRvz/cCSYdjchetiHog6cxlalfyCMiGhDb0NpzPCfTanAriO1gv3FAfkBBy3tbxZs9si6/b3zGFuNaNdFzAGVksMe35Z2DAvsMg43IvkVkXoYCANR5SqBKIajUBK38GuLBp4pd9V0ZrZXAdYd1OCVs7McljnrUVJ7jQJQ=
Message-ID: <4781C8B5.6050207@gmail.com>
Date: Mon, 07 Jan 2008 15:37:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071538.58875.rusty@rustcorp.com.au> <4781B234.7070805@gmail.com> <200801071628.11381.rusty@rustcorp.com.au>
In-Reply-To: <200801071628.11381.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 07 January 2008 16:01:40 Tejun Heo wrote:
>>> But we hit the same problems:
>>>
>>> 1) sg_chain loses information.  The clever chain packaging makes reading
>>> easy, but manipulation is severely limited.  You can append to your own
>>> chains by padding, but not someone elses.  This works for SCSI, but what
>>> about the rest of us?  And don't even think of joining mapped chains: it
>>> will almost work.
>> You can append by allocating one more element on the chain to be
>> appended and moving the last element of the first chain to it while
>> using the last element for chaining.
> 
> Hi Tejun,
> 
>    Nice try!  Even ignoring the ugliness of undoing such an operation if the 
> caller doesn't expect you to mangle their chains, consider a one-element sg 
> array. :(

Heh heh, that can be dealt with by skipping the first chain if the first
chain is empty after chaining.  Please take a look at
ata_sg_setup_extra() in the following.

http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=blob;f=drivers/ata/libata-core.c;h=32dde5bbc75ed53e89ac17040da2cd0621a37161;hb=c8847e473a4a2844244784226eb362be10d52ce9

That said, yeah, it's seriously ugly.  Restoring the original sg is ugly
too.  I definitely agree that we need some improvements here.

-- 
tejun
