Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYAGFB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYAGFB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYAGFBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:01:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:32658 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAGFBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gDkDd2YzUp5hGCp88x00diY8hFc2+Ougoftwr5bOe4jyB518rXU6RypsU25IatCbICXdTxBVgtleqZKBgAyYmwaoqQinZyz3l9g2LzDEsBffESucbxDunCyQEoFZPsyyp+/rPd0gdYK9A3ZPjCtx+Ekn9+ytBdkiHhOOO+45K0U=
Message-ID: <4781B234.7070805@gmail.com>
Date: Mon, 07 Jan 2008 14:01:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
References: <200712191731.26512.rusty@rustcorp.com.au> <1199547072.3399.15.camel@localhost.localdomain> <200801071538.58875.rusty@rustcorp.com.au>
In-Reply-To: <200801071538.58875.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rusty Russell wrote:
>> The other thing I note is that the problem you're claiming to solve with
>> sg_ring (the ability to add extra scatterlists to the front or the back
>> of an existing one) is already solved with sg_chain, so the only real
>> advantage of sg_ring was that it contains explicit counts, which
>> sg_table (in -mm) also introduces.
> 
> I just converted virtio using latest Linus for fair comparison, and it's still 
> pretty ugly.  sg_ring needs more work to de-scsi it.  sg_table is almost 
> sg_ring except it retains all the chaining warts.

I agree it's ugly.

> But we hit the same problems:
> 
> 1) sg_chain loses information.  The clever chain packaging makes reading easy, 
> but manipulation is severely limited.  You can append to your own chains by 
> padding, but not someone elses.  This works for SCSI, but what about the rest 
> of us?  And don't even think of joining mapped chains: it will almost work.

You can append by allocating one more element on the chain to be
appended and moving the last element of the first chain to it while
using the last element for chaining.  Join can be done by similar
technique using three element extra chain in the middle.  But, yeah,
it's ugly as hell.

-- 
tejun
