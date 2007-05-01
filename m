Return-Path: <linux-kernel-owner+w=401wt.eu-S1423550AbXEAGLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423550AbXEAGLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423569AbXEAGLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:11:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36395 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423550AbXEAGLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:11:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, Vivek Goyal <vgoyal@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	<1177902195.30071.203.camel@localhost.localdomain>
	<463572B7.90202@zytor.com>
	<1177909434.30071.216.camel@localhost.localdomain>
	<m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
	<1177990722.28659.39.camel@localhost.localdomain>
	<m18xc919im.fsf@ebiederm.dsl.xmission.com> <4636D200.3010406@goop.org>
Date: Tue, 01 May 2007 00:11:21 -0600
In-Reply-To: <4636D200.3010406@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 30 Apr 2007 22:37:04 -0700")
Message-ID: <m1irbdysxi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> I'm not going to worry about going farther until the patches in flight
>> settle down a little bit, but this looks promising.
>>   
>
> Is there any value in adding an "early-putchar" function pointer into
> the structure somehow?  I could easily arrange for the domain builder to
> put a bit of code into the domain so that the early boot code can emit
> something.

I don't think so.  Once we know what subarch it is we can do a specific
hypervisor call if we need to for early printing.  There are weird
issues like physical vs virtual that would seem to make anything more
generic very difficult to get right, because the code pointed at
would need to be fully pic.

So as a trivial hypervisor call certainly, but I'm pretty doubtful
about a function pointer.  

Then we can do:

if (xen)
   blah
else if (lguest)
   blah2


Eric
