Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670Ab0A2EL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0A2EL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660Ab0A2ELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:11:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52691
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659Ab0A2ELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:11:54 -0500
Date: Thu, 28 Jan 2010 20:12:06 -0800 (PST)
Message-Id: <20100128.201206.257650090.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100129102543.7af32673.sfr@canb.auug.org.au>
References: <20100128184423.40ce38fb.sfr@canb.auug.org.au>
	<20100128.052432.251700168.davem@davemloft.net>
	<20100129102543.7af32673.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jan 2010 10:25:43 +1100

> Hi Dave,
> 
> On Thu, 28 Jan 2010 05:24:32 -0800 (PST) David Miller <davem@davemloft.net> wrote:
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Thu, 28 Jan 2010 18:44:23 +1100
>> 
>> > I am still seeing these.  Is it my compiler version (gcc4.4.0)?
>> 
>> You can't turn on DEBUG_STRICT_USER_COPY_CHECKS and
>> expect a successful build.  It's for developers to
>> look at the errors that are generated and audit those
>> cases in detail.
> 
> These are defconfig builds and CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is
> not set in either case.

Simply ignore the warning then, I thought you were reporting
a build failure.

> I only do an i386 defconfig build and I don't get these warnings.

Looking at the specific case of net/core/pktgen.c:867

"len" is variable in the net/core/pktgen.c line that emits the
warning

Even though it is limited to "sizeof(name) - 1" via strn_len()'s
third argument, that's a lot to expect the compiler to dig into
and be able to conclude invariants from.

Please just ignore the warnings.

Thanks.


