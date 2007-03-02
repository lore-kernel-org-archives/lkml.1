Return-Path: <linux-kernel-owner+w=401wt.eu-S2992750AbXCBXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992750AbXCBXe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992753AbXCBXe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:34:27 -0500
Received: from jade.aracnet.com ([216.99.193.136]:44858 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992752AbXCBXeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:34:25 -0500
Message-ID: <45E8B459.8030001@BitWagon.com>
Date: Fri, 02 Mar 2007 15:33:45 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com> <45E8A300.9020001@redhat.com>
In-Reply-To: <45E8A300.9020001@redhat.com>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> John Reiser wrote:
> 
>>The value of ->sysenter_return is interpreted in user space by the
>>sysexit instruction; nobody else cares what the value is.  The kernel
>>is not required to provide a good value when vdso_enabled is zero,
>>because the kernel has not told the process that sysenter is valid
>>(by setting AT_SYSINFO.)
> 
> 
> Doesn't matter because a malicious user can still execute sysenter.
> We do have to deal with that somehow, so we have to put something
> safe in there.

All values are safe as far as the kernel is concerned.  The sysexit
instruction is the only consumer of the value.  The sysexit instruction
interprets the value as a _user_ virtual address, and jumps to it,
in _user_ mode.  If user code does not like jumping to a random address
when vdso_enabled is zero, then user code should not use sysenter
when vdso_enabled is zero.  But execution of kernel code is not
affected in any way regardless of the value.

I'd be happy to set ->sysenter_return to 0 (or any other suggested value)
when vdso_enabled is 0, but this would be a politeness only.  There is
no added security risk to the kernel by leaving it unset.

>>Correct.  Changing vdso_enabled from 0 to non-zero must be prepared
>>to lose this race if it is not prevented.  Ordinarily it won't matter
>>because the administrator will perform such changes at a "quiet" time.
>>
> 
> 
> We have to deal with all the possibilities here, too.

Documentation is one method of dealing with it.

-- 
John Reiser, jreiser@BitWagon.com
