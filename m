Return-Path: <linux-kernel-owner+w=401wt.eu-S1031436AbXEDRIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031436AbXEDRIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031440AbXEDRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:08:37 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031437AbXEDRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:08:34 -0400
Message-ID: <463B6888.20001@zytor.com>
Date: Fri, 04 May 2007 10:08:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>	<463B5643.1040204@zytor.com> <m1ejlwr036.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejlwr036.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>
>> I saw the 0x40(%esi) stack stuff, and I'm utterly puzzled by it.  There
>> is no reason one can't set up %esp to point to a hunk in ordinary memory
>> and use it?
> 
> That is what we are doing, remind me to make certain we have this
> field of the boot protocol documented as permanently reserved for
> this.
> 
> This comes from the relocatable kernel patches where we run the
> kernel where the bootloader chooses to put it assuming we are >= 1M.
> 
> The problem is that we don't have any IP relative data access
> instructions, we don't have a stack, and so the only valid address
> that we know is valid is %esi.  Once we compute where we are running
> we can setup a base address register and a stack and everything is
> easy, but the bootstrap to figure out where we are is just a little
> tricky.

Oh, right.  And this runs with interrupts off, so you only need one
dword.  That's fine, of course, although the location is a bit awkward.

	-hpa
