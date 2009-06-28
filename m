Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZF1VvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZF1VvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZF1Vu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:50:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44690 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZF1Vu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:50:57 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
	<20090628135235.10f9b153.akpm@linux-foundation.org>
	<20090628210054.GB6760@one.firstfloor.org>
	<20090628141829.d3c34ad3.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 14:50:55 -0700
In-Reply-To: <20090628141829.d3c34ad3.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 28 Jun 2009 14\:18\:29 -0700")
Message-ID: <m1k52wrps0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, oleg@redhat.com, earl_chew@agilent.com, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, andi@firstfloor.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 28 Jun 2009 23:00:54 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
>> > 
>> > When was the last time we saw a "warning: process `%s' used the
>> > obsolete bdflush system call" warning?  A quick google here says 2004. 
>> > Is that data?  A bit, I guess.
>> 
>> bdflush? 
>
> I don't understand your answer.
>
> Many years ago (guess: 2001/2002) the bdflush() syscall was deprecated
> and we did
>
> 	if (msg_count < 5) {
> 		msg_count++;
> 		printk(KERN_INFO
> 			"warning: process `%s' used the obsolete bdflush"
> 			" system call\n", current->comm);
> 		printk(KERN_INFO "Fix your initscripts?\n");
> 	}
>
> to encourage people to stop using it.  A brief search indicates that
> nobody has reported this message in 4-5 years.
>
> So to answer the question "how long must we leave things in place before
> removing them?", that's the only data I am aware of.

Good point.  I just did a quick search and I can find people hitting the
deprecated sysctl message in 2.6.30.  So next year might be too soon
to actually remove the code.  Still we can remove the internal APIs
for 2.6.32 so it is no big deal.

Eric

