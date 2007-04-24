Return-Path: <linux-kernel-owner+w=401wt.eu-S1422886AbXDXRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422886AbXDXRvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXDXRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:51:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:48261 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422886AbXDXRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pf3OMmKjGthW6YhVcjCDz72hMMC93oI2W23815Ji79HrHqHd1ZAXV11DnrT+2U0TzmhznOgxdpklqwXErhdL6n9lBLB2Ij7DQfbUoG69SsQqd2nP8n51ZN+cCkTyuWxlTr+/Od/XqSYpjmGkYQZXcYdD3N96o7I8v2OXyDHzsqU=
Message-ID: <462E43AF.2040305@gmail.com>
Date: Wed, 25 Apr 2007 02:51:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vincent Vanackere <vincent.vanackere@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [OOPS 2.6.21-rc7-mm1] kernel BUG at fs/sysfs/inode.c:272 (sysfs_drop_dentry)
References: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com>	<462E3177.4000901@gmail.com> <20070424103358.3be9efcd.akpm@linux-foundation.org>
In-Reply-To: <20070424103358.3be9efcd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Apr 2007 01:33:59 +0900 Tejun Heo <htejun@gmail.com> wrote:
> 
>> Vincent Vanackere wrote:
>>> Hi,
>>>
>>> I'm getting the following oops at boot with the latest -mm kernel :
>>> ---------------------------------------------------------------
>>> kernel BUG at fs/sysfs/inode.c:272
>> Known problem.  Working on it.  Thanks.
>>
> 
> If it had been known by me I wouldn't have released known-buggy code to
> people who need to be able to test other people's code too. (argh)
> 

It's the problem Cornelia reported in the thread the patch was posted.
Okay, somehow it's missing lkml on cc list.  I included everybody
related but missed lkml.  A lot of screw ups lately.  My apologies.
Currently, known problems are...

1. new sysfs_drop_dentry() not allowing drop of parent when it's not
empty.  Reported by Cornelia and this thread reports the same problem.
I'm working on it now.

2. using sysfs_dirent pointer as sysfs inode number doesn't work because
ino_t is smaller than ulong on some archs.  It's also broken for 32bit
apps on 64bit archs.  Updated patch just submitted for review.

3. Sysfs rename doesn't work.  I broke it during the first series of
sysfs updates.  Will fix in a few days.

Again, sorry for all the troubles.  I'll be more careful.

-- 
tejun
