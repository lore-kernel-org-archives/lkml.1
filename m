Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYIPHfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYIPHfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIPHfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:35:23 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:1681 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYIPHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QQ1eXgPk1cdQ8l27H746UMdLYwBV5MwuBOsMk5TWShVRFFPPYRBOycOduJoh9ybXBR
         1lGx2Moq07ssu0ggEQ0Y7/zSYMJBKnm7mQQzEftRn4biXsFvCnlNamxEnH9nPrdsANfo
         UMHOler52PUupWROTAuqL4AmLp3mppmTLSuWQ=
Message-ID: <a4423d670809160035s25fd5227j831492b3f43daa6a@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:35:20 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at shrink_icache_memory+0x38/0x1a8
In-Reply-To: <20080916025204.GL5811@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913233138.GA19576@orion> <20080916025204.GL5811@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/16 Dave Chinner <david@fromorbit.com>:
> On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
>> Hi
>>
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.27-rc6-00034-gd1c6d2e #3
>> -------------------------------------------------------
>> nfsd/1766 is trying to acquire lock:
>>  (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8
>>
>>  but task is already holding lock:
>>   (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
>>   xfs_ilock+0xa2/0xd6
>>
>>
>> I read files through nfs and saw delay for few seconds.
>> System is x86_32, nfs, xfs.
>> The last working kernel is 2.6.27-rc5,
>> I do not know yet is it reproducible or not.
>
> <sigh>
>
> We need a FAQ for this one. It's a false positive.  Google for an
> explanation - I've explained it 4 or 5 times in the past year and
> asked that the lockdep folk invent a special annotation for the
> iprune_mutex (or memory reclaim) because of the way it can cause
> recursion into the filesystem and hence invert lock orders without
> causing deadlocks.....

Hi Dave

Yes, you already explained a similar message to me, but it was a bug,
not false positive.
http://lkml.org/lkml/2008/7/3/29
http://lkml.org/lkml/2008/7/3/315

I will try to bisect.
It is not a OOM case.
