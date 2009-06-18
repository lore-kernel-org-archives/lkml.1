Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZFRDht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZFRDht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZFRDhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:37:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33155 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZFRDhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:37:41 -0400
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	<4A2CC52B.9010602@oracle.com>
	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	<m1ab4i11zx.fsf@fess.ebiederm.org>
	<20090611050929.GA2706@cr0.nay.redhat.com>
	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 20:37:40 -0700
In-Reply-To: <20090618030051.GA6133@cr0.nay.redhat.com> (Amerigo Wang's message of "Thu\, 18 Jun 2009 11\:00\:51 +0800")
Message-ID: <m1tz2ei54r.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tao.ma@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <xiyou.wangcong@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <xiyou.wangcong@gmail.com> writes:

> On Tue, Jun 16, 2009 at 12:27:36PM -0700, Eric W. Biederman wrote:
>>Américo Wang <xiyou.wangcong@gmail.com> writes:
>>>> I think a case can be made either way.  In practice neither answer
>>>> gives us a dense offset space on x86_64 so I think I prefer the
>>>> current definition which sets or clears the high bits as opposed
>>>> to something that mangles the address more.
>>>>
>>>
>>> I am trying to dig more... There must be something wrong there.
>>
>>How so?
>
> See what you will get for kc_vaddr_to_offset(__va(0))?
> It is supposed to be 0.

I see: 0x0000880000001000  That extra 0x1000 looks suspicous.

It MUST NOT be 0. That is where the ELF header lives in the file.

> Yes, I am cooking a patch set... will send them when ready.

The I will leave it to you.

Eric

