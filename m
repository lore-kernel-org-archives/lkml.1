Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbXGXRcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbXGXRcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbXGXRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:32:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:23257 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbXGXRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gJEuqWOOcLVlx86797q67SE7XFK2hE/0oP3kCPz1d23YRjN+isnMBzxZkxbbjTGXwu03j7UT4kJjXaJ5taMlWOSJizBpQZVdpCipbA3TUiTLVmkXDwrVxLeYNVPkZHJVHe44kjjb/qlG0YABrFE3yjvQiQEd/PDmZQFjFrw+3n8=
Message-ID: <86802c440707241032u21fc6150gb1cf52678e97b1ab@mail.gmail.com>
Date: Tue, 24 Jul 2007 10:32:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/10] try parent numa_node at first before using default v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ak@suse.de, clameter@sgi.com,
       cornelia.huck@de.ibm.com, davem@davemloft.net, greg@kroah.com,
       hch@infradead.org, rientjes@google.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46A5C105.20707@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707231323.57502.yinghai.lu@sun.com>
	 <46A5C105.20707@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> On 7/23/2007 10:23 PM, Yinghai Lu wrote:
> > this one already in -mm, but it needs [PATCH 1/10]
> >
> > [PATCH 3/10] try parent numa_node at first before using default v2
> [...]
> > this patch is using second method.
> [...]
>
> Could you shorten the patch description?
>
> Don't describe what your patch _does not_ do.  Don't even describe _how_
> your patch does what it does (unless it's obfuscated, but then that
> would be a bad patch anyway).
>
> Just describe _why_ it does something.
> --

Please check it is OK.

[PATCH 3/10] try parent numa_node at first before using default v2

in the device_add, we try to use use parent numa_node.
need to make sure pci root bus's bridge device numa_node is set.
then we could use device->numa_node direclty for all device.
and don't need to call pcibus_to_node().

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
