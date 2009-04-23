Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZDWRbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZDWRbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZDWRal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:30:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39646 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbZDWRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:30:39 -0400
Message-ID: <49F0A5A8.50308@redhat.com>
Date: Thu, 23 Apr 2009 13:30:16 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/3] crypto: properly handle null input and assoc data
 aead test vectors
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150936.10800.jarod@redhat.com> <20090420062301.GA1083@gondor.apana.org.au>
In-Reply-To: <20090420062301.GA1083@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2009 02:23 AM, Herbert Xu wrote:
> On Wed, Apr 15, 2009 at 09:36:10AM -0400, Jarod Wilson wrote:
>> Currenty, if either input or associated data are null in an aead
>> test vector, we'll have random contents of the input and assoc
>> arrays. Similar to the iv, play it safe and zero out the contents.
>>
>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
>
> This patch doesn't make sense unless you were getting a crash
> without it.
>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index bfee6e9..a8bdcb3 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -314,8 +314,18 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>>   			input = xbuf[0];
>>   			assoc = axbuf[0];
>>
>> -			memcpy(input, template[i].input, template[i].ilen);
>> -			memcpy(assoc, template[i].assoc, template[i].alen);
>> +			if (template[i].input)
>> +				memcpy(input, template[i].input,
>> +				       template[i].ilen);
>> +			else
>> +				memset(input, 0, MAX_IVLEN);
>
> If template[i].input was really NULL then the memcpy should crash.

I needed to do this for some extended testing elsewhere in 
similar-looking code, where input could indeed be NULL and I did 
encounter crashes, but its not reproduceable within tcrypt/testmgr 
itself, so indeed, not necessary here.

-- 
Jarod Wilson
jarod@redhat.com
