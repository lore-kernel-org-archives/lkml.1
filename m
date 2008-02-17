Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYBQUHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYBQUHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYBQUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:07:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:1734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYBQUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rQZoicXKjqAeyVv3U6PqA2LJ6KbrEyfD949arhzmIsAclxaC4tEJtmYGaIMyWNrbFHBS2TnsdA1iSBLj7pDAU2CPf48NDfA5cauNh7YnUfKIxlnj2hnrb5BzCSR1u/6pYxEgzhxLphmxwlB0mcWRp7Y5mJq/U8teMRhD/v33abI=
Date: Sun, 17 Feb 2008 23:06:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, ak@suse.de, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric
	constant
Message-ID: <20080217200654.GF31968@cvg>
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org> <20080217190801.GC31968@cvg> <47B88FAA.9080603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B88FAA.9080603@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, Feb 17, 2008 at 11:48:58AM -0800]
> Cyrill Gorcunov wrote:
>> Yes Sam, I've read Peter and Ingo comments on this patch
>> (actually I sent the same patch maybe week ago and Peter
>> and Ingo told me that we use %fs,%gs now for stack) but
>> as I pointed in comment - this alignment is still using
>> by Xen and lguest and even x86. So - it would be really
>> usefull for me if someone give me the last point - YES we
>> use such an alignment for stack, NO - we don't use it at all.
>> I was trying to hadle this myself - but I'm not a specialist
>> in this area you know ;)
>
> It bugs me quite a bit that paravirt clients contain this hack open-coded, 
> but that's not *your* fault.  There probably should be a macro to 
> encapsulate the stack pointer location for a specific thread.
>
> 	-hpa
>

Thanks Peter for comments. Peter could you clarify for me a bit
more on the string:

x86/kernel/head_32.S:339

	/* Set up the stack pointer */
	lss stack_start,%esp

but stack_start is defined as head_32.S:647

.data
ENTRY(stack_start)
	.long init_thread_union+THREAD_SIZE

so stack_start *must* be aligned with THREAD_SIZE in vmlinux.lds
at compiling time. There is no PDA at this booting time. Am I wrong?
If you're too busy - just reply me like "Read the code" ;)

		- Cyrill -
