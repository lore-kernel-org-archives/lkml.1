Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXEUQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXEUQP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXEUQPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:15:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:32383 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXEUQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eqBAhd0CkOjhZw6U+ldCtN4WGsuhSj7EmUittrJbDC2h511YtUxSKDn68jLSPsoXdMJrG09YHssPuTrICMIxUYN//zeDyX7hzZCNeARGUZVrVhHCZ2H752WOFpUzA0s8L9mrQViayqm1vOyrumSDvr/UE/amdyARtj9PKO2yexk=
Message-ID: <4651C589.2060106@gmail.com>
Date: Mon, 21 May 2007 18:15:05 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: maneesh@in.ibm.com, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry, take#2
References: <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com> <4651C2B3.10905@redhat.com>
In-Reply-To: <4651C2B3.10905@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Maneesh Soni wrote:
> 
>> Looks ok to me.. I have tested it it but unfortunately I couldn't
>> recreate the race without the patch also. It would be helpful if
>> people actually seeing the race, provide the test results.
>>
>> Greg, please merge this one once we have some test results.
> 
> I merged this back to RHEL4-era (2.6.9) kernels due to a report of this
> problem on RHEL4.  The tester could hit the sysfs_d_iput bug fairly
> easily before, and has not seen it with this patch in place.
> 
> The other bug they were seeing even more often was the sysfs_readdir()
> oops as we try to extract the inode number for regular sysfs files,
> again due to transient vnodes.  Is any fix for that problem being
> considered for -stable?  I had backported a simpler version of Tejun's
> s_ino fix for the problem, without the ida complexity - and brought a
> couple other small upstream fixes back to support that.  If nothing has
> yet been proposed for -stable, I can post that here.

I don't think any other fix has been proposed yet.  Please post them.
That definitely needs fixing.

-- 
tejun
