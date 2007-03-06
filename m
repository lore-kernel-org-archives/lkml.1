Return-Path: <linux-kernel-owner+w=401wt.eu-S965925AbXCFPVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965925AbXCFPVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965926AbXCFPVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:21:41 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54195 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965925AbXCFPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:21:41 -0500
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use a zero-size array in the struct devres
References: <20070306095241.28180.76390.stgit@localhost.localdomain>
	<45ED6221.5090003@gmail.com> <tnx649emo55.fsf@arm.com>
	<45ED818F.2030502@gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 06 Mar 2007 15:21:33 +0000
In-Reply-To: <45ED818F.2030502@gmail.com> (Tejun Heo's message of "Tue, 06
 Mar 2007 23:58:23 +0900")
Message-ID: <tnx1wk2mm82.fsf@arm.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2007 15:21:35.0003 (UTC) FILETIME=[2083DEB0:01C76003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Catalin Marinas wrote:
>> It sounds to me like the alignment of an incomplete type is not
>> guaranteed (as you can't even enquire about it, though I might be
>> wrong). This is probably dependent on the compiler as well - with
>> gcc-3.3 on x86, __alignof__(unsigned long long) is 8 but the
>> "offsetof(struct test, data)" below is 12 (and it doesn't make any
>> difference whether it is a 0-size array or not):
>> 
>> struct test {
>>     unsigned long a;
>>     unsigned long b;
>>     unsigned long c;
>>     unsigned long long data[];
>> };
>
> data[0] and data[1] or whatever will also give you offset of 12.  Dunno
> why, but it is.  Anyways, whatever the wording in the manual is,
> flexible arrays just have to have the required alignment to do its job
> as advertised.  :-)

On ARM (with gcc-4) it gives 16 for both offsetof and sizeof.

>> I did a quick grep through the kernel and it looks like Linux mainly
>> uses 0-size rather than flexible arrays at the end of a structure
>> (>500 vs ~14). This might be for historical reasons but it's not a big
>> issue in modifying them.
>
> I think it's mostly historical.  Flexible array is still a relatively
> new thing.  I don't mind changing devres to zero sized array, but please
> explain in the commit message and as a comment that the choice is for
> kmemleak's container_of(), and cc Greg K-H as the change should probably
> go through his tree.

OK. I'll probably wait until I post a new version of kmemleak against
2.6.21-rcX.

Thanks.

-- 
Catalin
