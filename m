Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185Ab0ALAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0ALAOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438Ab0ALAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:14:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0ALAOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:14:38 -0500
Message-ID: <4B4BBEBA.4060403@zytor.com>
Date: Mon, 11 Jan 2010 16:13:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	 <4B47E7A9.6090904@zytor.com>	 <1263250418.2859.681.camel@sbs-t61.sc.intel.com>	 <4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>	 <4B4BB0B7.3000106@zytor.com> <1263254812.2859.890.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263254812.2859.890.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 04:06 PM, Suresh Siddha wrote:
>>
>> Yes, that's what I said.  My question was to Suresh what enforces that
>> in the case of his patch, which moves the legacy range into the middle
>> of the device vectors.
> 
> It's not the used_vector bitmap. That range will appear as used on all
> the cpu's and hence we won't be allocating it for anything else.
> 

OK, fair enough.

> Now the question is: for non-legacy (io-apic) case, instead of reserving
> this range for all the cpu's, does it make sense to generalize like any
> other vector?

It sounds like something that we could experiment with -- after
switching an IRQ to ioapic mode, make it a movable interrupt.  It
*seems* it should work, but it's scary stuff to muck with.

Eric, do you see any reason why it wouldn't work?  I truly couldn't
understand your previous remark, especially the bit about "it is
dangerous to play lowest priority irq games in that range".

	-hpa


