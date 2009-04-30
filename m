Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbZD3SoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbZD3SoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761888AbZD3SoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:44:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55544 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZD3SoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:44:03 -0400
To: Joe Korty <joe.korty@ccur.com>
Cc: "venkatesh.pallipadi\@intel.com" <venkatesh.pallipadi@intel.com>,
       "mingo\@elte.hu" <mingo@elte.hu>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090430161506.GA2636@typhoon.ccur.com>
	<m11vra13z0.fsf@fess.ebiederm.org>
	<20090430180011.GB28139@tsunami.ccur.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 30 Apr 2009 11:43:55 -0700
In-Reply-To: <20090430180011.GB28139@tsunami.ccur.com> (Joe Korty's message of "Thu\, 30 Apr 2009 14\:00\:12 -0400")
Message-ID: <m11vrayob8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: joe.korty@ccur.com, linux-kernel@vger.kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Joe Korty <joe.korty@ccur.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0169]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_Symld_Words too many words that have symbols inside
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] clear irq pending when bypassing it
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty <joe.korty@ccur.com> writes:

> On Thu, Apr 30, 2009 at 12:49:39PM -0400, Eric W. Biederman wrote:
>> Joe Korty <jak@typhoon.ccur.com> writes:
>> 
>> > IRQ_MOVE_PENDING must be cleared whenever it is bypassed.
>> >
>> > Otherwise, we risk an old, pending affinity change
>> > overtaking and erasing a more recent affinity change that
>> > had been directly applied (eg, IRQ_MOVE_PCNTXT mode).
>> 
>> When can this happen?
>
> Probably doesn't happen.  AFAIK, each IRQ is either fully MSI
> or non-MSI.  The MSI IRQs will always use IRQ_MOVE_PCNTXT and
> the non-MSI's will never use IRQ_MOVE_PCNTXT.  Thus no collision.
>
> It could only happen if it was possible for a MSI and non-MSI
> device to share an IRQ.

Ok.  I thought you might have seen something.

It doesn't happen and it can't happen, making your patch wrong.

Eric





