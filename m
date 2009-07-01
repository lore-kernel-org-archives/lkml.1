Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGAXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGAXZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZGAXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:25:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43795 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZGAXZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:25:07 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com
References: <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 01 Jul 2009 16:25:05 -0700
In-Reply-To: <20090701144742.6ce3535b.akpm@linux-foundation.org> (Andrew Morton's message of "Wed\, 1 Jul 2009 14\:47\:42 -0700")
Message-ID: <m14otwq94e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, mtk.manpages@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, tao.ma@oracle.com, xiyou.wangcong@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RESEND Patch] kcore: remove its pointless size
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 30 Jun 2009 18:08:50 +0800
> Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> 
>> Linus fixes wrong size of /proc/kcore problem in commit 9063c61fd5cbd.
>> 
>> But its size still looks insane, since it never equals to the size
>> of physical memory.
>
> Better changelogs, please!
>
> I think that what you're saying is that the stat.st_size field of the
> /proc/kcore inode does not equal the amount of physical memory, and
> that you think it should do so?
>
> If that is correct then it would be appropriate to explain what value
> the stat.st_size field has before the patch and afterwards.  Just
> calling it "insane" isn't optimal.
>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: mtk.manpages@gmail.com
>> 
>> (Andrew, could you please just cut off the kernel part from below? :)
>> 
>> ---
>> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
>> index 59b43a0..eca5201 100644
>> --- a/fs/proc/kcore.c
>> +++ b/fs/proc/kcore.c
>> @@ -405,9 +405,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>>  static int __init proc_kcore_init(void)
>>  {
>>  	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
>> -	if (proc_root_kcore)
>> -		proc_root_kcore->size =
>> -				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>>  	return 0;
>>  }
>>  module_init(proc_kcore_init);
>
> AFAICT this means that proc_root_kcore->size will remain uninitialised
> until a process opens and reads from /proc/kcore.  So on initial boot
> the `ls' output will presumably show a size of zero, and this will
> change once /proc/kcore has been read?

Which is better than showing a random number of dubious relationship
to the size we normally show.  That code is just a maintenance problem.

> If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?
>
> In fact, do we need to run get_kcore_size() more than once per boot? 
>
> AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
> is called at the appropriate time, we can permanently cache its result?
>
> In which case get_kcore_size() and kclist_add() can be marked __init.
>
> Maybe that's all wrong - I didn't look terribly closely.

Memory hot add I expect is the excuse.  There is more that could be
done.  But this patch is an obvious bit of chipping away nonsense
code.

Eric

