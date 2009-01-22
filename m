Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZAVUQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZAVUQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZAVUQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:16:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55822 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAVUQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:16:30 -0500
Message-ID: <4978D3FD.4050300@hathawaymix.org>
Date: Thu, 22 Jan 2009 13:15:57 -0700
From: Shane Hathaway <shane@hathawaymix.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
References: <49752649.3000508@hathawaymix.org> <20090122162042.GH9732@hack.private>
In-Reply-To: <20090122162042.GH9732@hack.private>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=mx02.mta.xmission.com;;;ip=166.70.244.130;;;frm=shane@hathawaymix.org;;;spf=none
X-XM-DomainKey: sender_domain=hathawaymix.org;;;sender=shane@hathawaymix.org;;;status=no signature
X-SA-Exim-Connect-IP: 166.70.244.130
X-SA-Exim-Mail-From: shane@hathawaymix.org
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?****;Am=e9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0615]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: uml: sigprocmask fix
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Mon, Jan 19, 2009 at 06:18:01PM -0700, Shane Hathaway wrote:
>> I just ran into the same issue described here:
>>
>> http://lkml.org/lkml/2009/1/15/194
>>
>> Like Americo Wang, my user mode linux compile failed when attempting to
>> link ".tmp_vmlinux".  However, his patch is probably wrong.  The problem
>> is that the name "sigprocmask" is getting renamed to
>> "kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
>> that name gets mangled into "sys_kernel_sigprocmask" by the
>> SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.
> 
> 
> Hmmm, I found this, but note that replacing sigprocmask with
> kernel_sigprocmask is done by strip, that should be after compiling.
> But macros are processed before compiling.
> 
> Am I missing something?

Probably not, but have you made progress in figuring out why others can 
apparently successfully compile UML without patching sys_call_table.S at 
all?  That's the real mystery.

Shane
