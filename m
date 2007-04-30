Return-Path: <linux-kernel-owner+w=401wt.eu-S1423390AbXD3PfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423390AbXD3PfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423399AbXD3PfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:35:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53994 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423401AbXD3PfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:35:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
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
Date: Mon, 30 Apr 2007 09:34:20 -0600
In-Reply-To: <1177909434.30071.216.camel@localhost.localdomain> (Rusty
	Russell's message of "Mon, 30 Apr 2007 15:03:54 +1000")
Message-ID: <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Sun, 2007-04-29 at 21:38 -0700, H. Peter Anvin wrote:
>> Rusty Russell wrote:
>> > 
>> > Dammit, Eric, you spend a lot of time using words like "insane" where
>> > you mean we didn't do everything all at once.
>> > 
>> > It's *not* clear that using %esi is sane, but nothing in the current
>> > code prevents that.
>> 
>> Why not?
>
> (I assume you mean why isn't it clear?)
>
> Because VMI uses the presence of a ROM to indicate it's not native.  KVM
> uses a magic MSR IIRC.
>
> I think it makes sense for lguest to change over, tho.  Patches welcome
> 8)

Reading this it occurs to me what I object to wasn't that clear.

I have no problem with the testing of %cs to see if we are not in ring0.
That part while a little odd is fine, and we will certainly need a test
to skip the protected instructions in head.S

What I object to in particular is having (struct lguest_info?) instead
of using the standard format for kernel parameters pointed to in %esi.

Eric
