Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbXCTXoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbXCTXoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbXCTXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:44:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934089AbXCTXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:44:22 -0400
Date: Tue, 20 Mar 2007 16:43:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <20070320202352.GF4286@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703201626030.6730@woody.linux-foundation.org>
References: <20070319.204712.118947830.davem@davemloft.net>
 <m13b40wnrb.fsf@ebiederm.dsl.xmission.com> <200703201428.50564.ak@suse.de>
 <m1ircvswzz.fsf@ebiederm.dsl.xmission.com> <20070320174159.GA4286@bingen.suse.de>
 <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
 <20070320180359.GB4286@bingen.suse.de> <Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
 <20070320192118.GD4286@bingen.suse.de> <Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org>
 <20070320202352.GF4286@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Andi Kleen wrote:

> On Tue, Mar 20, 2007 at 11:49:39AM -0700, Linus Torvalds wrote:
> > 
> > the thing is, I'd rather see a long backtrace that is hard to decipher but 
> > that *never* *ever* causes any additional problems, over a pretty one.
> 
> Well it causes additional problems. We had some cases where it was really
> hard to distingush garbage and the true call chain. I can probably dig
> out some examples if you want.

Well, by "additional problems" _I_ mean things like "a warning turned into 
a fatal oops and didn't get logged at all".

That's a lot more serious than "there were a few extra entries in the 
traceback that caused us some confusion".

And yes, we had exactly that case happen several times.

> With lots of call backs (e.g. common with sysfs) it is also frequently
> not obvious how the call chains are supposed to go.

With callbacks, it's actually often nice to see the callback data that is 
on the stack (and it's very obvious from the "<function+0>" ksymtab 
explanation: you can't have a <function+0> that is anything but a callback 
pointer (since it isn't a return address).

		Linus
