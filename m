Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZB0LwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZB0LwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZB0LwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:52:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZB0LwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:52:08 -0500
Message-ID: <49A7D3E5.5040706@redhat.com>
Date: Fri, 27 Feb 2009 12:52:05 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete	function
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au>
In-Reply-To: <20090227114103.GB24024@gondor.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 04:56:11PM +0800, Huang Ying wrote:
>> @@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
>>  		return;
>>  	}
>>  
>> -	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
>> +	mempool_free(dmreq->req, cc->req_pool);
> 
> Why do we need all this complexity? Can't just fix it by using
> cc->req?

No. There can be parallel req allocated, also cc->req can be NULL.
(seems that these structs are overcomplicated already:-)

(And becuse sometimes the bio request is split into 2 pieces because
of hw restrictions, there can be two ablkcipher_requests for one bio...)

I think that patch is the best what we can do now as bugfix.
(I am just running some tests with that.)

Milan
--
mbroz@redhat.com

