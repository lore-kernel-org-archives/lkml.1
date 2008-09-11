Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYIKONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYIKONR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIKONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:13:00 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51899 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYIKOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=v/p58dAPvSNGeLDOP31jK3hEvq26DLBEHEQvtiqEWMuG1bkLqVWzRHYvM0MejJSYK+
         2/Now5SuBm1cxjDE7s4yfPZSqbxJvWde0hDDmUB6FI08AufC99soQYrl3pdSEVxzZxBO
         ctGskYmqwg75q+171EqCTQx22v1hmRF9x/qJY=
Message-ID: <41b516cb0809110712t45baa383y10650d8c6e4961c4@mail.gmail.com>
Date: Thu, 11 Sep 2008 07:12:57 -0700
From: "Chris Leech" <christopher.leech@intel.com>
Reply-To: chris.leech@gmail.com
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] 24-bit types: typedef and functions for accessing 3-byte arrays as integers
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net,
       "Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <48C8D0E0.5060908@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080911021448.23621.42553.stgit@localhost.localdomain>
	 <48C8D0E0.5060908@panasas.com>
X-Google-Sender-Auth: 05775e690d7aea0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 1:03 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> diff --git a/fs/jfs/endian24.h b/fs/jfs/endian24.h
>> index fa92f7f..45b6397 100644
>> --- a/fs/jfs/endian24.h
>> +++ b/fs/jfs/endian24.h
>> @@ -33,6 +33,9 @@
>>               ((__x & (__u32)0x00ff0000UL) >> 16) )); \
>>  })
>>
>> +#undef __cpu_to_le24
>> +#undef __le24_to_cpu
>> +
>
> Does #undef also work on inline functions? I didn't know that

No, it doesn't and those two lines don't do anything.  The two below
do, so this file gets touched anyway, and the JFS patch deletes the
entire file.  I'll fix this is there's some other reason to redo the
patchset again.

>>  #if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
>>       #define __cpu_to_le24(x) ((__u32)(x))
>>       #define __le24_to_cpu(x) ((__u32)(x))
>> @@ -42,6 +45,8 @@
>>  #endif
>>
>>  #ifdef __KERNEL__
>> +     #undef cpu_to_le24
>> +     #undef le24_to_cpu
>>       #define cpu_to_le24 __cpu_to_le24
>>       #define le24_to_cpu __le24_to_cpu
>>  #endif
