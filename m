Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbXJBGYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbXJBGYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXJBGY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:24:26 -0400
Received: from gw.goop.org ([64.81.55.164]:37855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXJBGYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:24:25 -0400
Message-ID: <4701E418.7010603@goop.org>
Date: Mon, 01 Oct 2007 23:24:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
References: <470186C4.5080208@goop.org> <4701DBB9.9020202@qumranet.com>
In-Reply-To: <4701DBB9.9020202@qumranet.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> The code doesn't support having both lazy modes active at once.  Maybe
> that's not an issue, but aren't the two modes orthogonal?

Hm, well, that's a good question.  The initial semantics of the lazy
mode calls were "what VMI wants", and they're still not really nailed
down.  VMI doesn't support having both active at once, and its a little
unclear what it would mean anyway.  For now, we don't support multiple
lazy modes active at once, and the kernel never tries to do it (in fact,
it would be a bug, since lazy mmu must be preempt disabled, and lazy cpu
is only used for context switches).

>
>> --- a/arch/i386/xen/multicalls.h
>> +++ b/arch/i386/xen/multicalls.h
>> @@ -35,7 +35,7 @@ void xen_mc_flush(void);
>>  /* Issue a multicall if we're not in a lazy mode */
>>  static inline void xen_mc_issue(unsigned mode)
>>  {
>> -    if ((xen_get_lazy_mode() & mode) == 0)
>> +    if ((paravirt_get_lazy_mode() & mode) == 0)
>>          xen_mc_flush();
>
> This snippet looks like it wants to support concurrently active lazy
> modes.

Yeah, its a little more general than it needs to be.

    J

