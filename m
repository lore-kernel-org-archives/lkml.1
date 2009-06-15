Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZFOKLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZFOKLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZFOKK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:10:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34218 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:10:58 -0400
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	<4A2CC52B.9010602@oracle.com>
	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	<m1ab4i11zx.fsf@fess.ebiederm.org>
	<20090611050929.GA2706@cr0.nay.redhat.com>
	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	<m17hzg7oil.fsf@fess.ebiederm.org>
	<20090615021457.GA3388@cr0.nay.redhat.com> <4A35E32C.30609@oracle.com>
	<20090615070018.GD3544@cr0.nay.redhat.com>
	<4A360793.6060000@oracle.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Jun 2009 03:10:57 -0700
In-Reply-To: <4A360793.6060000@oracle.com> (Tao Ma's message of "Mon\, 15 Jun 2009 16\:34\:27 +0800")
Message-ID: <m1ski1g632.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tao.ma@oracle.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, xiyou.wangcong@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tao Ma <tao.ma@oracle.com>
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

Tao Ma <tao.ma@oracle.com> writes:

> Hi Amerigo,
>
> The wrong number I mean is 131941393240064.
>
> So do you think
> [root@test3 ~]# ls -l /proc/kcore
> -r-------- 1 root root 131941393240064 Jun 15 13:39 /proc/kcore
>
> is better than
>
> [taoma@test2 ~]$ ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun 15 15:20 /proc/kcore
> ?
>
> I don't think so.
>
> Actually the right result should look like
>
> [root@test8 ~]# ls -l /proc/kcore
> -r-------- 1 root root 5301604352 Jun 15 13:35 /proc/kcore
>
> And with your patch I can't get this number.

Actually that value is the bug.  It has absolutely nothing
to do with the offsets that are valid within /proc/kcore.

Why do you prefer the smaller number?

Eric
