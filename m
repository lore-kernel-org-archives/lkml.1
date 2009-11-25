Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZKYOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZKYOo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZKYOo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:44:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:43068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZKYOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:44:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gaC2m1/c4+XfvxPAIwP/nxb3bHAyKFimu1C4JgzNuW8SdibsLj+qZaV5JLag3mvVvV
         wUogAThTrQM4ql0kVVbPHZ47OfjFMRUNoMzE9pOSENarVRj+swOjF4kmmeOSwI0lJcON
         Kl3WOJSVZO+pd5c+Yzl8MUjLBeUserH6OCOdQ=
Date: Wed, 25 Nov 2009 22:45:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Liuweni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>,
       jack <jack@suse.cz>, npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>
Subject: Re: [PATCH 2/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091125144539.GA3520@hack>
References: <200911252212166092236@gmail.com> <20091125141727.GI9482@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125141727.GI9482@parisc-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 07:17:28AM -0700, Matthew Wilcox wrote:
>On Wed, Nov 25, 2009 at 10:12:19PM +0800, Liuweni wrote:
>> @@ -605,8 +605,8 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
>>  {
>>  	unsigned long tmp;
>>  
>> -	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
>> -			L1_CACHE_BYTES;
>> +	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) >>
>> +			L1_CACHE_SHIFT;
>>  	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
>>  	return tmp & I_HASHMASK;
>>  }
>
>Have you compared the compiler output before/after your change?  I'd be
>amazed if GCC isn't able to optimise division-by-a-constant-power-of-two
>into shift-by-constant.

If a compiler can't do this nowadays, I'd consider it's a bug.

-- 
Live like a child, think like the god.
 
