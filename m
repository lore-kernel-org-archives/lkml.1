Return-Path: <linux-kernel-owner+w=401wt.eu-S1031429AbXEDRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031429AbXEDRFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031426AbXEDRFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:05:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36594 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031429AbXEDRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:05:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>
	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>
	<463B5643.1040204@zytor.com>
Date: Fri, 04 May 2007 11:05:17 -0600
In-Reply-To: <463B5643.1040204@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 08:50:27 -0700")
Message-ID: <m1ejlwr036.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> 
>> Yes, that's more or less the same code, aside from using 0x40(%esi) as a
>> stack.  Would that be OK here?
>> 
>
> I saw the 0x40(%esi) stack stuff, and I'm utterly puzzled by it.  There
> is no reason one can't set up %esp to point to a hunk in ordinary memory
> and use it?

That is what we are doing, remind me to make certain we have this
field of the boot protocol documented as permanently reserved for
this.

This comes from the relocatable kernel patches where we run the
kernel where the bootloader chooses to put it assuming we are >= 1M.

The problem is that we don't have any IP relative data access
instructions, we don't have a stack, and so the only valid address
that we know is valid is %esi.  Once we compute where we are running
we can setup a base address register and a stack and everything is
easy, but the bootstrap to figure out where we are is just a little
tricky.

Eric
