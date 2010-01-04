Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700Ab0ADTDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0ADTDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526Ab0ADTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:03:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0ADTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:03:06 -0500
Message-ID: <4B423B08.3010005@zytor.com>
Date: Mon, 04 Jan 2010 11:01:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	<4B398ECD.1080506@kernel.org>	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	<4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org> <m1aawtlu6y.fsf@fess.ebiederm.org>
In-Reply-To: <m1aawtlu6y.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 08:18 AM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
> This patch is wrong.
> 
>> between FIRST_EXTERNAL_VECTOR (0x20) and FIRST_DEVICE_VECTOR (0x41)
>>
>> for 0x20 and 0x2f, we are safe be used_vectors will prevent it to use used one.
> 
> We can not use any of 0x20 - 0x2f for ioapic irqs.  We need the entire
> priority level to ensure that the irq move cleanup ipi is of a lower
> priority.
> 

Almost makes one want to abuse 0x1f for that.  Although 0x00..0x1f are
reserved for exceptions, the APICs range down to 0x10, and well, when
0x1f ends up actually getting used as an exception vector that we
support, then we can trivially change that.  In the meantime it would
actually make use of an otherwise-unusable APIC priority level.

	-hpa
