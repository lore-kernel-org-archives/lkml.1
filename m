Return-Path: <linux-kernel-owner+w=401wt.eu-S1031024AbXEAGFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024AbXEAGFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030782AbXEAGFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:05:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40294 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423560AbXEAGFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:05:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
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
	<4636B7DE.5050005@zytor.com> <4636BB6B.9070300@zytor.com>
	<1177995014.28659.54.camel@localhost.localdomain>
	<4636D017.5060108@zytor.com>
Date: Tue, 01 May 2007 00:05:09 -0600
In-Reply-To: <4636D017.5060108@zytor.com> (H. Peter Anvin's message of "Mon,
	30 Apr 2007 22:28:55 -0700")
Message-ID: <m1mz0pyt7u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Rusty Russell wrote:
>> 
>> BTW, wrt. a new "platform type" field, should it go something like this?
>> 
>> -0235/3	N/A	pad2		Unused
>> +0235/1	2.07+	platform_type	Runtime platform (see below)
>> +0236/2	N/A	pad2		Unused
>> ...
>> +  platform_type:
>> +	For kernels which can boot on multiple platforms.  Currently
>> +	0 == native (normal), 1 == lguest (paravirtualized).
>> 
>
> Well, yes, but we need to think about if there is more things that
> should be added.  There *definitely* should be space for a platform data
> pointer, to start out with.  I would also like to see a platform data
> field, as well as a bootloader extension field (we're going to have that
> problem soon enough.)

Well in the paravirt case since we are starting virtually mapped
if we don't start with vmlinux but bzImage we need to define what
that virtual address space should contain, and where in the address
space it is safe to put those page tables.

Of the requirements I have heard so far that is the trickiest one.
Because it basically requires us to have a reasonable worst case
estimate of how much memory we are going to use before we start using
the bootmem allocator.

Eric
