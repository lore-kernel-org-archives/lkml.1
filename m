Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477Ab0ABX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0ABX5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955Ab0ABX5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:57:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:36488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0ABX5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:57:45 -0500
Message-ID: <4B3FDE90.9070803@kernel.org>
Date: Sun, 03 Jan 2010 09:02:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sysfs: Add lockdep annotations for the sysfs active reference
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>	<20091226094504.GA6214@liondog.tnic>	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>	<m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org> <m11vi8yyrb.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m11vi8yyrb.fsf_-_@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2010 06:37 AM, Eric W. Biederman wrote:
> 
> Holding locks over device_del -> kobject_del -> sysfs_deactivate can
> cause deadlocks if those same locks are grabbed in sysfs show or store
> methods.
> 
> The I model s_active count + completion as a sleeping read/write lock.
> I describe to lockdep sysfs_get_active as a read_trylock,
> sysfs_put_active as a read_unlock, and sysfs_deactivate as a
> write_lock and write_unlock pair.  This seems to capture the essence
> for purposes of finding deadlocks, and in my testing gives finds real
> issues and ignores non-issues.
> 
> This brings us back to holding locks over kobject_del is a problem
> that ideally we should find a way of addressing, but at least lockdep
> can tell us about the problems instead of requiring developers to debug
> rare strange system deadlocks, that happen when sysfs files are removed
> while being written to.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Looks good to me.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks for doing this.

-- 
tejun
