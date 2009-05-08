Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbZEHEvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbZEHEvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZEHEvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:51:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45863 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZEHEvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:51:07 -0400
Message-ID: <4A03BA34.5080201@redhat.com>
Date: Fri, 08 May 2009 00:51:00 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] crypto: add infra to skip disallowed algs in fips
 mode
References: <200905071441.27093.jarod@redhat.com> <200905071527.59809.jarod@redhat.com> <20090508021233.GA20388@gondor.apana.org.au>
In-Reply-To: <20090508021233.GA20388@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2009 10:12 PM, Herbert Xu wrote:
> On Thu, May 07, 2009 at 03:27:59PM -0400, Jarod Wilson wrote:
>> Because all fips-allowed algorithms must be self-tested before they
>> can be used, they will all have entries in testmgr.c's alg_test_descs[].
>> If we add and set an additional flag for the allowed algorithms, we can
>> key off of it to prevent use of any algs that aren't allowed.
>>
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>>
>> ---
>>  crypto/testmgr.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index f4cc178..232f043 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -94,6 +94,7 @@ struct alg_test_desc {
>>  	const char *alg;
>>  	int (*test)(const struct alg_test_desc *desc, const char *driver,
>>  		    u32 type, u32 mask);
>> +	int fips_allowed;	/* set if alg is allowed in fips mode */
>>  
>>  	union {
>>  		struct aead_test_suite aead;
> 
> Please merge this chunk with the second patch into one and have
> it as the first patch.  We want this to be bisectable.

D'oh. I actually was attempting to make it bisectable, but now I see
that w/fips mode enabled, you wouldn't be able to use any algs with
them split this way if you landed between 'em. I'll repost shortly.

-- 
Jarod Wilson
jarod@redhat.com

