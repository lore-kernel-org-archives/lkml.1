Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbXEWIVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbXEWIVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXEWIVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:21:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:46145 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbXEWIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X77uD2fZjFbWzHT4d/VJL0clWtlQpTMIFDHP416HNReWKQpv16Zz3YU0c1MKGE+8LA7LB5ycuT/ATYDLZl5ediDq3+8qXZ3ZA4AtvwBZxb6lEI1kP3SiY/q9WGkPnmKkGrk5ukrsw6MX88pgMaQjbkqvWfVZpqTvlByrgsjIJZ8=
Message-ID: <4653F98A.8080308@gmail.com>
Date: Wed, 23 May 2007 10:21:30 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Maneesh Soni <maneesh@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry,	take#2
References: <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com> <20070522223841.GB2874@kroah.com>
In-Reply-To: <20070522223841.GB2874@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, May 21, 2007 at 10:31:01AM +0530, Maneesh Soni wrote:
>> On Thu, May 17, 2007 at 08:16:10PM +0200, Tejun Heo wrote:
>>> Allowing attribute and symlink dentries to be reclaimed means
>>> sd->s_dentry can change dynamically.  However, updates to the field
>>> are unsynchronized leading to race conditions.  This patch adds
>>> sysfs_lock and use it to synchronize updates to sd->s_dentry.
>>>
>>> Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
>>> is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
>>> validity of the dentry is protected by dcache_lock, so whether dentry
>>> is alive or not can only be tested while holding both locks.
>>>
>>> This is minimal backport of sysfs_drop_dentry() rewrite in devel
>>> branch.
>>>
>>> DONT APPLY JUST YET
>> Looks ok to me.. I have tested it it but unfortunately I couldn't
>> recreate the race without the patch also. It would be helpful if
>> people actually seeing the race, provide the test results.
>>
>> Greg, please merge this one once we have some test results.
> 
> Can someone just resend it after those test results are in, with the
> proper signed-off-by, so I know it's safe to apply?

I'll resend with S-O-B after someone verifies it fixes the problem.

-- 
tejun
