Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZHSSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZHSSjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZHSSjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:39:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57748 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZHSSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:39:40 -0400
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>,
       linux-kernel@vger.kernel.org
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
	<4A80C2F8.2040208@gmail.com>
	<d12c1890908101825t44138bf4x9a4733ece6f74b88@mail.gmail.com>
	<d12c1890908111528p47cdd30bw24749e34fc1cc8d3@mail.gmail.com>
	<4A835760.2050803@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Aug 2009 11:39:38 -0700
In-Reply-To: <4A835760.2050803@gmail.com> (Robert Hancock's message of "Wed\, 12 Aug 2009 17\:59\:28 -0600")
Message-ID: <m14os3lkb9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, lfpg.dev@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robert Hancock <hancockrwd@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> On 08/11/2009 04:28 PM, Luis Fernando Planella Gonzalez wrote:
>> I'm really concerned that all those interrupts might slow down the
>> computer somehow...
>> Here is an attached syslog part after a reboot.
>> Sometimes, the ratelimit says that thousands of callbacks were suppressed.
>> Is there a way to make this message be displayed only once?
>>
>> In arch/x86/kernel/irq.c, the line 213 is:
>> irq = __get_cpu_var(vector_irq)[vector];
>>
>> In my case, the returned irq is -1. Doesn't it makes sense to not log
>> the "No irq handler for vector" message when irq<  0?
>>
>> Or even a deeper answer: Why, in my case, the resulting irq is -1?
>
> Not logging would just cover up the problem, the issue in your case is that
> something seems to be asserting a ton of interrupts on an IRQ line that no
> driver has claimed..

It is slightly worse.  We are seeing interrupts asserted and we don't
know which IRQ line they belong to.  This should never happen.

You say it is first 0.99 and 0.91 so it is moving.

Luis are you running a 64bit kernel?  I think you would have to be
for your symptoms to go all of the way back to 2.6.24.

My primary suspect is that something the irq migration code is not
working properly on your computer.  Could you disable
/usr/sbin/irqbalance (possibly just by deleting it) and tell me if
that fixes your symptoms?

If not we have a very nasty bug in how your ioapics are being programmed.

Eric
