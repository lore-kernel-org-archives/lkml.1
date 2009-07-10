Return-Path: <linux-kernel-owner+w=401wt.eu-S1751323AbZGJHw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbZGJHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZGJHwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:52:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39895 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZGJHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:52:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A56F343.7040907@jp.fujitsu.com>
Date: Fri, 10 Jul 2009 16:52:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
CC: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdump: Enable kdump if 2nd-kernel is loaded.
References: <4A55A4AE.3000206@mxs.nes.nec.co.jp> <4A56E069.5040907@jp.fujitsu.com> <4A56E83B.50600@mxs.nes.nec.co.jp>
In-Reply-To: <4A56E83B.50600@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohmichi-san,

Ken'ichi Ohmichi wrote:
> Hidetoshi Seto wrote:
>> I'd like to quote your comment:
>>
>>>> I tried to test a kdump on linux-2.6.31-rc1 *without* a kernel parameter
>>>> "oops=panic" by `echo c > /proc/sysrq-trigger`, but a kdump did not work
>>>> because a kdump, which is occurred by `echo c > /proc/sysrq-trigger`, has
>>>> been changed to a NULL pointer error instead of calling crash_kexec()
>>>> since linux-2.6.31-rc1.
>> So the real problem is that kdump is not triggered by the NULL pointer oops
>> if !panic_on_oops, isn't it?
>>
>> It seems that you should report this trouble of sysrq-c as a regression.
> 
> I don't think this problem is a regression of sysrq-c.
> This change of sysrq-c looks reasonable to me. Because sysrq-c is used
> for the test of kdump, and its code path has been changed to the same
> path as a kdump on oops (a real problem, not test).
> So we can test a kdump by a real oops, that is good to me.
> As a result, I could find this problem a kdump is not enabled without
> "oops=panic".

Still I believe this is a regression of sysrq-c.
If required function of sysrq-c were "cause a real oops", then it is not
regression.  But as described in Documentation/sysrq.txt, real usage of
sysrq-c is "perform a kexec reboot," i.e. kdump.
So I think sysrq-c should use panic instead of oops if it want to kick
the kdump unconditionally.

However, yes, I agree it is a problem on the kdump's policy that kdump on
oops is not enabled without the option.  I'm not sure how much people want
to enable kdump only on panic while not on oops, but I suppose it will be
negligible.  Or it would be better to introduce kdump_on_oops option or so.


Thanks,
H.Seto

