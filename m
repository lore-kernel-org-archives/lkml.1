Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXFHOfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXFHOfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbXFHOfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:35:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:58738 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969328AbXFHOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dUJMm4f0XTZaYx5KQH/tP0Fex2kAQ3CYw8apaweDd+52+6VvWoQypQS93LqxZ+pSpHkILlocq2rkvzuwnLSlGzwWvjBmn0VRBySZKBqaA/dkEkJlEHHdGqB4xoYNsh44OwfMNqhYEbW2lQTFxxrJVTwlXeQeWcQ1LSmi0MlUUIA=
Message-ID: <46696917.50004@gmail.com>
Date: Fri, 08 Jun 2007 23:35:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Greg KH <greg@kroah.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry,	take#2
References: <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com> <20070522223841.GB2874@kroah.com> <4653F98A.8080308@gmail.com>
In-Reply-To: <4653F98A.8080308@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Greg KH wrote:
>> On Mon, May 21, 2007 at 10:31:01AM +0530, Maneesh Soni wrote:
>>> On Thu, May 17, 2007 at 08:16:10PM +0200, Tejun Heo wrote:
>>>> Allowing attribute and symlink dentries to be reclaimed means
>>>> sd->s_dentry can change dynamically.  However, updates to the field
>>>> are unsynchronized leading to race conditions.  This patch adds
>>>> sysfs_lock and use it to synchronize updates to sd->s_dentry.
>>>>
>>>> Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
>>>> is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
>>>> validity of the dentry is protected by dcache_lock, so whether dentry
>>>> is alive or not can only be tested while holding both locks.
>>>>
>>>> This is minimal backport of sysfs_drop_dentry() rewrite in devel
>>>> branch.
>>>>
>>>> DONT APPLY JUST YET
>>> Looks ok to me.. I have tested it it but unfortunately I couldn't
>>> recreate the race without the patch also. It would be helpful if
>>> people actually seeing the race, provide the test results.
>>>
>>> Greg, please merge this one once we have some test results.
>> Can someone just resend it after those test results are in, with the
>> proper signed-off-by, so I know it's safe to apply?
> 
> I'll resend with S-O-B after someone verifies it fixes the problem.

Have been trying to reproduce the problem on the latest -rc but haven't
succeeded yet.  It seems I lost my magic recipe for these races.  Did
anyone succeed?

-- 
tejun
