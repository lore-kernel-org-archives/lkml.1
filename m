Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXEVAVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXEVAVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbXEVAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:21:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696AbXEVAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:21:00 -0400
Message-ID: <465236EF.40102@redhat.com>
Date: Mon, 21 May 2007 19:18:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Maneesh Soni <maneesh@in.ibm.com>,
       stable@kernel.org
Subject: Re: [stable] [PATCH] - fix oops in sysfs_readdir
References: <4651E0C9.3080609@redhat.com> <20070521153935.b549db8f.akpm@linux-foundation.org>
In-Reply-To: <20070521153935.b549db8f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 21 May 2007 13:11:21 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> This is a non-ida backport of Tejun's patch in -mm at:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
>> for the 2.6.16 -stable tree - it follows the same scheme of using s_ino to safely
>> store & retrieve the inode number of sysfs entries for use in sysfs_readdir,
>> but uses a brain-dead-simple inode nr allocator rather than ida, which would
>> bring along a lot of newer, more complex code.
>>
>> No, this doesn't guarantee uniqueness of sysfs inode numbers, but then
>> the code in -stable today doesn't either - and with this change, at least
>> it shouldn't oops.
> 
> So I'm sitting here whether to commend this patch to google kernel maintainers
> for 2.6.18 backport, but I realise I don't know what it does.  And I don't know
> if it fixes the reclaim-time oopses they were intermittently seeing, or if it
> fixes something else and if so what that is.
> 
> Sigh.  Better changelogs, please.
> 

Sorry Andrew.  I referenced Tejun's upstream patch in -mm which has a 
nice changelog etc, and this is a backport of that, and does the same 
thing in the same way and solves the same problem - but that doesn't 
help if you just want to toss this message into your patch stack.  Will 
fix up & resend.

-Eric

-Eric
