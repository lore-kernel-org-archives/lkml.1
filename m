Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643Ab0ADTv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0ADTv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848Ab0ADTvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:51:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0ADTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:51:23 -0500
Message-ID: <4B42467F.5040008@zytor.com>
Date: Mon, 04 Jan 2010 11:50:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	 <4B398ECD.1080506@kernel.org>	 <4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	 <4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>	 <m1aawtlu6y.fsf@fess.ebiederm.org> <4B423B08.3010005@zytor.com>	 <m1my0thelq.fsf@fess.ebiederm.org>  <4B424305.7050803@kernel.org> <1262634353.2700.49.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1262634353.2700.49.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 11:45 AM, Suresh Siddha wrote:
> On Mon, 2010-01-04 at 11:35 -0800, Yinghai Lu wrote:
>> sth like this?
>>
>> Subject: [PATCH 1/2] x86: get back 16 vectors
>>
>> -v2: according to hpa that we could start from 0x10
>>      according to Eric, we should hold 16 vectors for IRQ MOVE
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> Yinghai we have to change IRQ_MOVE_CLEANUP_VECTOR to 0x1f or so. From
> the cpu perspective this vector is documented as illegal, so we need to
> check if this change will work on the cpu's we have today to get some
> confidence.
> 

It's documented as reserved, not illegal.  The ability for the APIC to
generate vectors starting at 0x10 is documented, as is the ability for
the CPU to receive any vector number as an interrupt -- in fact, the
legacy BIOS relies on being able to receive interrupts starting at
vector 0x08.  It causes problems galore, but only at the software level.

	-hpa
