Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYHTSQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYHTSQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYHTSP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:15:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:35329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYHTSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VIVjeN3rpehx6U/OiMgVJFy/omJ8ixceU7UQTQLGO4ScRuCPiId1ipfBIKJGZfiE4n
         1WHMHTMDQrQiy8lwyGpHJYhMeCvd9c9Cv9BMGfoJVYOb5AF79C1MfuLI2fnyWRZRFAdy
         VG2BKZv8WIZ6eJfDaUNoOed7igEjky2JMyIpA=
Message-ID: <2c0942db0808201115v3025e5f6r6c882783fa9e29f3@mail.gmail.com>
Date: Wed, 20 Aug 2008 11:15:55 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, adobriyan@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Aneesh Kumar KV" <aneesh.kumar@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Chris Friesen" <cfriesen@nortel.com>
In-Reply-To: <200808210355.55597.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1912217169.25608.228.camel@ymzhang>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
	 <1219252901.8651.63.camel@twins>
	 <200808210355.55597.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 14ddf3225bbb189d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:55 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 21 August 2008 03:21, Peter Zijlstra wrote:
>> Ok, so one last time (I hope!)..
>>
>> Everybody happy with this?
>
>
>> Index: linux-2.6/include/linux/kernel.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/kernel.h
>> +++ linux-2.6/include/linux/kernel.h
>> @@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
>>       (void) (&_max1 == &_max2);              \
>>       _max1 > _max2 ? _max1 : _max2; })
>>
>> +#define avg(x, y) ({                         \
>> +     typeof(x) _avg1 = (x);                  \
>> +     typeof(y) _avg2 = (y);                  \
>> +     (void) (&_avg1 == &_avg2);              \
>> +     _avg1 + (_avg2 - _avg1)/2; })
>
> That's not going to work with unsigned types.

Uhm, I think it works fine, even with unsigned, even where _avg2 is
smaller than _avg1. Underflow is a good thing here. And I mocked up a
little test harness and it gives the correct answers for a half dozen
sets of values I tossed at it

But maybe I'm forgetting an obscure unsigned or signed int type
widening rule, so, care to elaborate?
