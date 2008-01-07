Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYAGIqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYAGIqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYAGIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:45:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10965 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbYAGIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wvm+A9YwZEKBwuspnodwh1y7gegkcJHpQnJO5zUiWdvUBkfbWX2QqCBEzsZak0uid+e2dB1TO0T2zjlI2uIuCBYlcCUhwAcI456DfCEhCklQwcAgh3E1KHX+B5xCXvDEP00zSok1eTglH1/+4zVGE4dUc7ZMiiJm6BHWdhVDKbE=
Message-ID: <4781E6BB.2010900@gmail.com>
Date: Mon, 07 Jan 2008 17:45:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071628.11381.rusty@rustcorp.com.au> <4781C8B5.6050207@gmail.com> <200801071934.01597.rusty@rustcorp.com.au>
In-Reply-To: <200801071934.01597.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 07 January 2008 17:37:41 Tejun Heo wrote:
>> Rusty Russell wrote:
>>> Hi Tejun,
>>>
>>>    Nice try!  Even ignoring the ugliness of undoing such an operation if
>>> the caller doesn't expect you to mangle their chains, consider a
>>> one-element sg array. :(
>> Heh heh, that can be dealt with by skipping the first chain if the first
>> chain is empty after chaining.  Please take a look at
>> ata_sg_setup_extra() in the following.
>>
>> http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=blob;f=driver
>> s/ata/libata-core.c;h=32dde5bbc75ed53e89ac17040da2cd0621a37161;hb=c8847e473a
>> 4a2844244784226eb362be10d52ce9
>>
>> That said, yeah, it's seriously ugly.  Restoring the original sg is ugly
>> too.  I definitely agree that we need some improvements here.
> 
> Erk, that's beyond ugly, into actual evil.

/me agrees.

> To make this general you need to find the last N 1-element chains (but SCSI 
> doesn't do this of course).  Oh the horror...

/me agrees.

> I'd be remiss if I didn't mention that the sg_ring ata patches were 
> straightforward, and indescribably beautiful if compared to this!

/me agrees.  As long as this can be made sane using one unified
interface, I don't care whether it's sg_ring, table or dish.

Thanks.

-- 
tejun
