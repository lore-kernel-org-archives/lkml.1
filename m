Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXEDPXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXEDPXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXEDPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:23:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47835 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbXEDPXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:23:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>
	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>
Date: Fri, 04 May 2007 09:22:47 -0600
In-Reply-To: <463B49F0.401@goop.org> (Jeremy Fitzhardinge's message of "Fri,
	04 May 2007 07:57:52 -0700")
Message-ID: <m13b2csjeg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> BTW, I should have marked this as an RFC comment, rather than an actual
> submission.  We don't need it for .22.
>
>> NAK.  
>>
>> Skipping the segment register load is likely fine.
>> Supporting V!=P at startup_32 is not.
>>   
>
> Why?
>
>> Assuming that we have a stack at startup_32 is not.
>>
>> If you want to figure out where the kernel is loaded you can do
>> (from arch/i386/boot/head.S)
>>   
>
> Yes, that's more or less the same code, aside from using 0x40(%esi) as a
> stack.  Would that be OK here?

Using 0x40 as a stack would be ok.

There are issues with CONFIG_RELOCATABLE and V!=P that I'm not
comfortable with yet, because we can't tell the difference.

Eric
