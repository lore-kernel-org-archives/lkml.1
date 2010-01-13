Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301Ab0AMUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0AMUgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810Ab0AMUgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:36:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33494 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0AMUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:36:31 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
	<4B4BB0B7.3000106@zytor.com>
	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>
	<4B4BBEBA.4060403@zytor.com> <m17hro6ua9.fsf@fess.ebiederm.org>
	<4B4BC401.6010605@zytor.com> <m1k4vo144h.fsf@fess.ebiederm.org>
	<4B4BDBBA.3090406@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 13 Jan 2010 12:36:18 -0800
Message-ID: <m1vdf57nel.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/11/2010 05:52 PM, Eric W. Biederman wrote:
>> 
>> After having the documentation quoted at me.  I am having a distinct
>> memory of one piece of documentation saying:
>> "interrupts within a priority level can be delivered in any order"
>> 
>> So I am guessing there is not any ordering of interrupts in the same
>> priority level until they get to the local apic.
>> 
>
> There is no ordering of interrupts before they hit the local APIC, since
> the local APIC is what would serialize them...

The io apic serializes them, and sends them over either the 2-wire
bus or the front side bus.   How much serialization and prioritization
happens at that point I am not certain, but some certainly happens
before you get to the local apic.

Eric

