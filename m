Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbXCTQIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbXCTQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXCTQIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:08:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbXCTQI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:08:28 -0400
Date: Tue, 20 Mar 2007 09:06:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <m1mz27sy82.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0703200903500.6730@woody.linux-foundation.org>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org>
 <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net>
 <20070318120814.GA45869@muc.de> <1174272469.11680.23.camel@localhost.localdomain>
 <m1648xxf93.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
 <1174348905.11680.54.camel@localhost.localdomain> <45FF4043.4000805@vmware.com>
 <45FF770C.7050301@goop.org> <Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org>
 <m1mz27sy82.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Eric W. Biederman wrote:
> 
> If that is the case.  In the normal kernel what would
> the "the oops, we got an interrupt code do?"
> I assume it would leave interrupts disabled when it returns?
> Like we currently do with the delayed disable of normal interrupts?

Yeah, disable interrupts, and set a flag that the fake "sti" can test, and 
just return without doing anything.

(You may or may not also need to do extra work to Ack the hardware 
interrupt etc, which may be irq-controller specific. Once the CPU has 
accepted the interrupt, you may not be able to just leave it dangling)

But I was throwing that out as a long-term thing. I'm not claiming it's 
trivial, but it should be doable.

		Linus
