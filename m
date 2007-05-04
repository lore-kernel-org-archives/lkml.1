Return-Path: <linux-kernel-owner+w=401wt.eu-S1031426AbXEDRIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031426AbXEDRIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031435AbXEDRIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:08:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031426AbXEDRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:08:17 -0400
Message-ID: <463B683C.5090308@zytor.com>
Date: Fri, 04 May 2007 10:07:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>	<463B551E.8030701@zytor.com> <463B5B90.20308@goop.org> <m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> We have real mystery historical cases in Gujin and ELILO.  So it
> probably makes sense at this point to force a gdt reload if we can and
> otherwise require all of the segments %ds, %es, %fs, %gs to be loaded
> with a valid segment, that we can reach everything we need to touch
> from.
> 

I think we should avoid using %fs and %gs (no use for them, anyway); but
 I think it's a decent expectation to have %cs, %ds, %es, and %ss set up.

Gujin seems to have a near-zero user community, so if they have to rev
their code it wouldn't be a big deal (the author keeps trying to push
some crack-smoking "Gujin native" patches into the kernel, too), but
breaking ELILO would hurt anyone using Intel Macs.

	-hpa
