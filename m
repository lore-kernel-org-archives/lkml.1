Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0BOGdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:33:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0BOGdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:33:17 -0500
Message-ID: <4B78EB39.9020008@redhat.com>
Date: Mon, 15 Feb 2010 14:35:37 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Miles Lane <miles.lane@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, akpm@linux-foundation.org
Subject: Re: [RFC Patch] sysfs: add marks for mutable sysfs files
References: <20100210065754.3713.8997.sendpatchset@localhost.localdomain> <m1aavh3roj.fsf@fess.ebiederm.org>
In-Reply-To: <m1aavh3roj.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
> 
>> NOTE: This patch is only a draft, not ready to be taken.
>>
>> This fixes all the s_active related bogus lockdep warnings that I received,
>> I already tested it, it works fine for cpu hotplug, I/O scheduler switch,
>> and suspend.
>>
>> This patch introduces sever sysfs/kobject interfaces to add mutable
>> sysfs files or kobjects, those files could be removed by the kernel
>> during some event, e.g. cpu hotplug. All of this kind of sysfs files
>> should use these API's, to avoid the deadlock warnings.
>>
>> I am still not sure if this is the best fix.
>>
>> Please comment.
> 
> mutable as you describe it happens to be the common case, and that
> class of files is not free from this class of problem.
> 
> Your patch is actively wrong if it solves the i/o scheduler issue,
> as those files are in fact mutable by your definition, block devices
> are hot pluggable.
> 
> Having a special case for permanent sysfs files, that we refuse to
> delete would be reasonable, but it certainly does not cover
> everything.
> 

(Sorry for the delay, we are having Chinese new year here.)

Oh, yes, I just worried that if my patch is aggressive.
I saw your patch, will have a review now.

Thank you!

