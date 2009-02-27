Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZB0IlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZB0IlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZB0IlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:41:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZB0IlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:41:08 -0500
Message-ID: <49A7A71E.50702@redhat.com>
Date: Fri, 27 Feb 2009 09:41:02 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: Bug of dm-crypt?
References: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com> <20090227054147.GA22159@gondor.apana.org.au>
In-Reply-To: <20090227054147.GA22159@gondor.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 01:31:56PM +0800, Huang Ying wrote:
>> I had ever heard from you that the only thing guaranteed in the
>> completion function of async ablkcipher cryption is the req->data has
>> the value you set before. The request pointer itself may be changed. But
>> in dm-crypt, I found they rely on request pointer in completion
>> function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.
>>
>> Do you think that is a bug?
> 
> Absolutely.
> 
> It should use cc->req instead.

ok, I'll check it and try to fix that. 

Can you send me backtrace from that panic?

What's wrong in async callback now - mempool_free using async_req directly?

(Btw in some previous discussuion I asked if cryptd can be used
for some kind of parallel speedup for dm-crypt in async mode and response
was that cryptd "is only meant to be a demo showing how an async
implementation should be written".

So this changed to real working thread for AES-NI?)

Milan
--
mbroz@redhat.com

