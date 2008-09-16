Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYIPEbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYIPEbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 00:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYIPEb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 00:31:29 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:35845 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbYIPEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 00:31:28 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at shrink_icache_memory+0x38/0x1a8
Date: Tue, 16 Sep 2008 14:31:05 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <7iduc45t9dvo0396fm78d8uat84uurh131@4ax.com>
References: <20080913233138.GA19576@orion> <20080916025204.GL5811@disturbed>
In-Reply-To: <20080916025204.GL5811@disturbed>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 12:52:04 +1000, Dave Chinner <david@fromorbit.com> wrote:

>On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
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
><sigh>
>
>We need a FAQ for this one. It's a false positive.  Google for an
>explanation - I've explained it 4 or 5 times in the past year and
>asked that the lockdep folk invent a special annotation for the
>iprune_mutex (or memory reclaim) because of the way it can cause
>recursion into the filesystem and hence invert lock orders without
>causing deadlocks.....

Yeah, but a 30 second dreadlock?  It's a long wait wondering what's 
gone down or not ;)

Grant.
