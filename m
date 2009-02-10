Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZBJO1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZBJO1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZBJO0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:26:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:43876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZBJO0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:26:53 -0500
Message-ID: <49918E86.4020304@kernel.org>
Date: Tue, 10 Feb 2009 23:26:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209141209.GA24323@elte.hu> <499186FB.4070506@kernel.org> <49918C3C.8030208@kernel.org> <20090210142026.GD16147@elte.hu>
In-Reply-To: <20090210142026.GD16147@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 14:26:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> I'll try other compilers but which version are you using?  The
>>> difference is that before the patchset, -fno-stack-protector was
>>> always added whether stackprotector was enabled or not so this problem
>>> wasn't visible (at the cost of bogus stackprotector of course).  We'll
>>> probably need to add __stack_chk_guard or disable if gcc generates
>>> such symbol.  I'll play with different gccs.
>> Can't reproduce with gcc-4.1 or 4.2.  Any chance you're using distcc
>> w/ a build machine w/ glibc < 2.4?  __stack_chk_guard is the symbol
>> gcc fetches stack canary from if TLS is not supported, so somehow gcc
>> thought that TLS wasn't available while building head64.
> 
> yeah - i also used distcc. Maybe the nostackp makefile magic gets confused
> about that?

It seems that even with the same gcc versions, gcc built against libc
w/o TLS support generates __stack_chk_guard, so if you mix the two
flavors, the has-stack-protector check can be compiled on machines w/
TLS while some other files end up being built on machines w/o TLS
support thus circumventing the support check.  Can you please see
whether non-distcc build fails too?

Thanks.

-- 
tejun
