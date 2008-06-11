Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYFKLu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYFKLu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYFKLuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:50:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:26760 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYFKLt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IJPS/eY+bWvzdUhLMdRLNcWwbzTdRGfiAdfaBhKPhilIZG1U8965pBNEDNj62zqbns
         BpCUi8yrdITYFr4tjDHV9+jishrEaqlqhMVQy83vSuD2y6JrLeNcYnF+Uw0jON0TkUoP
         YpNEgZfOZ0a6HoSJ1QQxy5P3593/CWMgJ6TI4=
Message-ID: <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
Date: Wed, 11 Jun 2008 12:49:56 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Cc: akpm@linux-foundation.org, "Andreas Dilger" <adilger@sun.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080611113104.GC9008@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
X-Google-Sender-Auth: 8437c32fe436e91f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/11 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
>> +/* Mask out flags that are inappropriate for the given type of inode. */
>> +static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
>> +{
>> +     if (S_ISDIR(mode))
>> +             return flags;
>> +     else if (S_ISREG(mode))
>> +             return flags & ~EXT4_REG_FLMASK;
>> +     else
>> +             return flags & ~EXT4_OTHER_FLMASK;
>> +}
>> +
>
> why are the arguments __le32 ? They should be in host order.
>
> static inline  __u32 ext4_mask_flags(umode_t mode, __u32 flags)

Whoops, I was matching the fields in ex4_inode, but I should have been
looking at ext4_inode_info. Shouldn't sparse have complained about
that?

Thanks,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
