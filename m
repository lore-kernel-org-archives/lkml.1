Return-Path: <linux-kernel-owner+w=401wt.eu-S1764636AbXJZSYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764636AbXJZSYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXJZSYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:24:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36383 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXJZSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:24:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
	<47222AFA.9030902@zytor.com>
Date: Fri, 26 Oct 2007 12:22:39 -0600
In-Reply-To: <47222AFA.9030902@zytor.com> (H. Peter Anvin's message of "Fri,
	26 Oct 2007 10:59:22 -0700")
Message-ID: <m1k5p920sw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> Both x86 and x86_64 support the same boot protocol so we need
>> to implement the KEEP_SEGMENTS on x86_64 as well.  It isn't
>> just paravirt bootloaders that could use this functionality.
>>
>
> Out of curiousity, what other users do you see?

Simply that is easier to provide segments that are not fit to be
reloaded before the kernel sets up it's own GDT.  Then to ensure you
stick a GDT someplace that won't get stomped.

Especially before we froze which segments numbers the kernel
would load into the boot protocol.  I would have used this in
places where I was doing 32bit bootloader work as it is just easier to
support.

Eric
