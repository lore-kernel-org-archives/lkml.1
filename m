Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbYETWad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbYETWad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYETWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:30:22 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:19356 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760AbYETWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=umadpvZOoeIe8pRltySQ4+6YB7+MNv1NawmbOXhcUIUyYmLz4UTiS4vpmDoVJ4XXg5WzjSuR6vqmd9W8s/i4Vxw5WwrgIje40762Ni2LkAlqd1cJBcIBojf8NnodHrf1uJmGyuYS05Fhc+KVjKxSzq6GFyjjYOtgR5o0tnRni7E=
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080520.151951.239145609.davem@davemloft.net>
References: <1211311449.5915.195.camel@brick>
	 <20080520.141731.99514303.davem@davemloft.net>
	 <1211321725.5915.208.camel@brick>
	 <20080520.151951.239145609.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:30:19 -0700
Message-Id: <1211322619.5915.218.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 15:19 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Tue, 20 May 2008 15:15:25 -0700
> 
> > Obviously I missed that part, my apologies.  Would it be acceptable if,
> > taking the possibly arch-specific parts, moved the [endian]_to_cpup
> > name over to get_[endian]
> 
> Why are we fiddling with interface names that have been fine for about
> 10 years?

Saw a lot of (or similar in a private helper):

*(__be32 *)ptr = cpu_to_be32(val);

So I came up with

void put_be32(val, ptr);

This looked a lot like the put_unaligned_be32 helpers and only left a
gap that was get_be32(ptr).

But this was exactly the same as the existing be32_to_cpup, so I wasn't
sure if I should add it or not.  In the end I just went ahead and did
it and wanted to see what the patch would be like moving over existing
users to the new api looked like.

On top of that I did the cpu_to_be32p removal, which probably was not
the brightest thing ever.

So, that leaves (repeat for various endian values, be32 is an example):

1) should put_be32(val, ptr) be added (it seems useful and lots of code
is already rolling their own if they aren't opencoding it)

2) should get_be32 be added purely to have a symmetric api, even through
it is equivalent to be32_to_cpup? (nice that it looks just like
get_unaligned_be32...makes alignment explicit)

3) if 2) should existiing be32_to_cpup users be moved over to the new
api

4) if 3) should cpu_to_be32p be moved/changed at all (unlikely)

I hope that explains where I was coming from with this set of patches.

Harvey



