Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYDKBRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYDKBRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYDKBQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:16:52 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:34360 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYDKBQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:16:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgFACZZ/kdMQWoK/2dsb2JhbACBXal3
Date: Thu, 10 Apr 2008 21:16:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: Re: [patch 16/17] Immediate Values - Documentation
Message-ID: <20080411011647.GA2785@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152052.245356400@polymtl.ca> <200804101333.36419.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200804101333.36419.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:13:11 up 41 days, 21:24,  6 users,  load average: 0.47, 0.49,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thursday 10 April 2008 01:08:45 Mathieu Desnoyers wrote:
> > If you have to read the immediate values from a function declared as
> > __init or __exit, you should explicitly use _imv_read(), which will fall
> > back on a global variable read. Failing to do so will leave a reference to
> > the __init section after it is freed (it would generate a modpost
> > warning).
> 
> That's a real usability wart.  Couldn't we skip these in the patching loop if 
> required and revert so noone can make this mistake?
> 

Yeah, I know :(

Well, only if we can find a way to detect the macro is put within a init
or exit section. Is there some assembly trickery that would permit us to
do that ?

Otherwise, given the memory freed from the init section could be reused
later by the kernel, I don't see how we can detect the pointer leads to
a freed init section and, say, a module.

Mathieu

> Thanks,
> Rusty.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
