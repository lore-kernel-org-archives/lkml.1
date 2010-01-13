Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871Ab0AMUyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0AMUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087Ab0AMUyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:54:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0AMUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:54:42 -0500
Message-ID: <4B4E32B3.6090400@zytor.com>
Date: Wed, 13 Jan 2010 12:53:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	<4B47E7A9.6090904@zytor.com>	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>	<4B4BB0B7.3000106@zytor.com>	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>	<4B4BBEBA.4060403@zytor.com> <m17hro6ua9.fsf@fess.ebiederm.org>	<4B4BC401.6010605@zytor.com> <m1k4vo144h.fsf@fess.ebiederm.org>	<4B4BDBBA.3090406@zytor.com> <m1vdf57nel.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdf57nel.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 12:36 PM, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 01/11/2010 05:52 PM, Eric W. Biederman wrote:
>>>
>>> After having the documentation quoted at me.  I am having a distinct
>>> memory of one piece of documentation saying:
>>> "interrupts within a priority level can be delivered in any order"
>>>
>>> So I am guessing there is not any ordering of interrupts in the same
>>> priority level until they get to the local apic.
>>>
>>
>> There is no ordering of interrupts before they hit the local APIC, since
>> the local APIC is what would serialize them...
> 
> The io apic serializes them, and sends them over either the 2-wire
> bus or the front side bus.   How much serialization and prioritization
> happens at that point I am not certain, but some certainly happens
> before you get to the local apic.
> 

>From the looks of the original 82093AA spec, the 2-wire bus did
round-robin between different APICs (including IOAPICs), and the IOAPIC
had no ordering guarantees whatsoever.

	-hpa

