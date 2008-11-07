Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYKGCPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYKGCPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYKGCPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:15:20 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46556 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGCPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:15:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
Date: Thu, 06 Nov 2008 18:05:46 -0800
In-Reply-To: <20081106172617.dd51d0af.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 6 Nov 2008 17:26:17 -0800")
Message-ID: <m1abccxpc5.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 06 Nov 2008 02:48:35 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> +void proc_shrink_automounts(void)
>> +{
>> +	struct list_head *list = &proc_automounts;
>> +
>> +	mark_mounts_for_expiry(list);
>> +	mark_mounts_for_expiry(list);
>
> Strange.  In case the first attempt didn't work?

Yes.  I'd like to say.  Mount just go away but it takes two passes before
a mount is actually removed.

For NFS which does the whole expiry of all inodes where it comes from it
is a good fit.  For /proc where we don't have to guess it isn't the best
fit but it isn't shabby either.

>
>> +	if (list_empty(list))
>> +		return;
>> +
>> +	schedule_delayed_work(&proc_automount_task, proc_automount_timeout);
>> +}


Eric
