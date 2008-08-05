Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYHELMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYHELMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYHELK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:10:29 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:58224 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYHELK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:10:29 -0400
Message-ID: <48983521.9070203@aitel.hist.no>
Date: Tue, 05 Aug 2008 13:10:25 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Arjan van de Ven <arjan@infradead.org>,
       Chris Mason <chris.mason@oracle.com>, dwmw2@infradead.org,
       austin_zhang@linux.intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c algorithm
 by new crypto API.
References: <1217866496.29139.75.camel@think.oraclecorp.com> <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au> <20080804100605.4f0921f4@infradead.org> <20080804171017.GA13725@gondor.apana.org.au> <20080804171316.GA13819@gondor.apana.org.au>
In-Reply-To: <20080804171316.GA13819@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Tue, Aug 05, 2008 at 01:10:17AM +0800, Herbert Xu wrote:
>   
>> I don't see why you couldn't do that for the crypto API too
>> if you wanted to.  That way it would benefit all crypto users
>> rather than just the crc32c (note the extra c) users.
>>     
>
> Anyway, the point here is the crc32c is nothing special.  It's
> just one out of many algorithms that has/will have hardware
> acceleration support.
>
> Rather than doing ad-hoc implementations and optimising that
> whenever such a thing pops up, let's spend our effort in creating
> a common platform that can be reused.
>   
How about making crc32c an inline function then?
On processors that have this feature, this compiles to that single
instruction, plus whatever setup it needs. Nice and efficient.
On other processors, either inline the algorithm or inline
a call to an out of line function, depending on how bulky this is.

Similiar for any other functions that may or may not have hw support.

Helge Hafting
