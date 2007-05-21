Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXEUQKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXEUQKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXEUQJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:09:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbXEUQJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:09:58 -0400
Message-ID: <4651C2B3.10905@redhat.com>
Date: Mon, 21 May 2007 11:02:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry, take#2
References: <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com> <20070521050101.GC9214@in.ibm.com>
In-Reply-To: <20070521050101.GC9214@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maneesh Soni wrote:

> Looks ok to me.. I have tested it it but unfortunately I couldn't
> recreate the race without the patch also. It would be helpful if
> people actually seeing the race, provide the test results.
> 
> Greg, please merge this one once we have some test results.

I merged this back to RHEL4-era (2.6.9) kernels due to a report of this
problem on RHEL4.  The tester could hit the sysfs_d_iput bug fairly
easily before, and has not seen it with this patch in place.

The other bug they were seeing even more often was the sysfs_readdir()
oops as we try to extract the inode number for regular sysfs files,
again due to transient vnodes.  Is any fix for that problem being
considered for -stable?  I had backported a simpler version of Tejun's
s_ino fix for the problem, without the ida complexity - and brought a
couple other small upstream fixes back to support that.  If nothing has
yet been proposed for -stable, I can post that here.

Thanks,

-Eric
