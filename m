Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZFIEKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZFIEKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbZFIEKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:10:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39035 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZFIEKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:10:12 -0400
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <20090605075614.GC8171@cr0.nay.redhat.com>
	<20090605095155.GC8354@cr0.nay.redhat.com>
	<4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>
	<4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>
	<20090608015242.GB2596@cr0.nay.redhat.com>
	<4A2CA96D.3090502@oracle.com>
	<2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	<4A2CC52B.9010602@oracle.com>
	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 21:10:10 -0700
In-Reply-To: <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
 (=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Tue\, 9 Jun 2009
 08\:43\:34 +0800")
Message-ID: <m1ab4i11zx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tao.ma@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Am=c3=a9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64  2.6.30-rc8.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Jun 8, 2009 at 4:00 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>>>
>>>> But the result is the same
>>>
>>> Yes?
>>> Your printk() shows kcore size is: 5301604352, and in your subject it is
>>> 281474974617600...
>>>
>>> Or they happened in the same time?
>>
>> yes. the same box and the same linux version.
>> A bit strange.
>>
>> [taoma@ocfs2-test2 ~]$ dmesg|grep "high memory"
>> high memory ffff88013c000000, size 5301604352
>> [taoma@ocfs2-test2 ~]$ ll /proc/kcore
>> -r-------- 1 root root 281474974617600 Jun  8 15:20 /proc/kcore
>
> Really weird...
> They should be the same. This means we have some problem in our procfs.
>
> And, we have no problem on i386, I, myself, even can't reproduce this on my
> x86_64 box...
>
> Drop Cc to x86 people, add some Cc to proc people. :)
>
> Eric, Alexey, any ideas?
>
> Tao, would you like to send us your .config? Thanks.

Short of some strange patch applied I would guess that a non-sense /proc/kcore
size is related to a kernel memory stomp, stepping on the high_memory variable.

Eric

