Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZKIDoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZKIDoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZKIDoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:44:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47656 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZKIDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:44:02 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<200911081306.20201.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 19:44:02 -0800
In-Reply-To: <200911081306.20201.arnd@arndb.de> (Arnd Bergmann's message of "Sun\, 8 Nov 2009 13\:06\:20 +0000")
Message-ID: <m1r5s88irh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Sunday 08 November 2009 12:16:43 Eric W. Biederman wrote:
>> This patchset reimplements sys_sysctl as a compatibility wrapper
>> around /proc/sys.  After which it removes all of the code to all over
>> the kernel that is used today to implement the binary sysctls.
>> 
>> I am posting this patchset to give everyone a heads up what is in
>> flight.
>> 
>> I intend to carry all of these patches in my sysctl tree.
>
> Very nice patches again!
>
> Looking at what you did, I had two ideas how to move on from there,
> which may be part of your plans already:
>
> 1. Make it possible to build sysctl_binary.c as a loadable module
> so you can get a smaller kernel without losing the option to use
> binary sysctl altogether. This of course requires a small portion
> to remain in the kernel, to provide the actual syscall entry point
> and load the module on demand.

I can see how this could make sense from a distribution perspective.

> 2. On top of that, put the same code into glibc so that you don't
> even have to load the module when you're running a new glibc version.
> Since the binary sysctl ABI is stable (as in stiff and dead), there
> should be no need to synchronize any extensions to it betwen kernel
> and libc.

I don't expect we will need to move this to glibc.  There are so few
users of sys_sysctl now, that I hardly expect it to be worth it to move
this code out of the kernel.

For me the big problem with sys_sysctl is solved by this patchset.
It no longer constitutes a maintenance burden on the rest of the sysctl
code, and the other sysctl users.

Now the implementation of /proc/sys can be implemented and optimized without
dealing with any sys_sysctl baggage.

All of that said if someone is interested in tweaking sysctl_binary.c to make
it easier to deal with sys_sysctl going away I don't have any problems.

Eric
