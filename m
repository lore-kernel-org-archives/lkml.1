Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbYGXDCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbYGXDCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYGXDCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:02:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43532 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYGXDCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:02:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, andi@firstfloor.org, arjan@infradead.org,
       ebiederm@xmission.com, greg@kroah.com, linux-kernel@vger.kernel.org
References: <200807231252.20371.yhlu.kernel@gmail.com>
	<20080723131218.f03ed672.akpm@linux-foundation.org>
Date: Wed, 23 Jul 2008 19:56:07 -0700
In-Reply-To: <20080723131218.f03ed672.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 23 Jul 2008 13:12:18 -0700")
Message-ID: <m17ibcf0s8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0536]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: usb debug port early console
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 23 Jul 2008 12:52:20 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> 
>> 
>> based on work from Eric, and add some timeout so don't dead loop when debug
> device
>> is not installed
>> 
>>
>> ...
>>
>> +static void dbgp_mdelay(int ms)
>> +{
>> +	int i;
>> +	while (ms--) {
>> +		for (i = 0; i < 1000; i++)
>> +			outb(0x1, 0x80);
>> +	}
>> +}
>
> hm.  port 80 has a guaranteed one microsecond? 

It usually longer, but it is in the 1 microsecond ballpark, accurate
enough to be a usable delay before we have anything else.

> Why not udelay()/mdelay()/etc?

This code runs ages before udelay and mdelay work.  Certainly before
calibrate delay is called, so the normal kernel delay routines don't
come anywhere close and an out to port 0x80 comes.

>> +static void dbgp_breath(void)
>> +{
>> +	/* Sleep to give the debug port a chance to breathe */
>> +}
>
> I expect the compiler will optimise away any calls to this.

It is documentation that is if it might be a good idea to not hit the
hardware there.

Eric
