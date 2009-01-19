Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZASNbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZASNbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZASNbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:31:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52466 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZASNbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:31:21 -0500
Message-ID: <4974809C.3030904@redhat.com>
Date: Mon, 19 Jan 2009 15:31:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
References: <1232370050-7434-1-git-send-email-avi@redhat.com> <20090119130927.GC6876@elte.hu> <49747C44.1030901@redhat.com> <20090119132214.GA20722@elte.hu>
In-Reply-To: <20090119132214.GA20722@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., would be nice to somehow untangle consciously-exported interface 
> definitions from kernel side bits, and standardize these 
> feature/capability flags like __KVM_HAVE_IOAPIC, etc.
>
> Right now we have this body of 75,000 lines of code spread out in 600+ 
> header files that are so-called 'exported' to user-space, but 95% of that 
> interface definition code is never being relied on by any user-space bit! 
> They are exported due to cargo-cult mentality or due to dependencies.
>
> It would be far better to have an explicit place for such bits, 
> include/syscall-ABI/ or so - and not export _any_ other kernel headers. 
> But that's a much larger project.
>   

Yes, kvm has non-interface stuff in <linux/kvm_host.h>, so there's at 
least some separation.  All of <linux/kvm.h> is needed by userspace.

What's more painful to me in this area is advertising what's exported.  
Right now userspace has to rely on the kernel version to see what 
features are supported, but that doesn't work if a feature is backported 
or removed.  KVM has KVM_CHECK_EXTENSION which I'd love to see standardized.

-- 
error compiling committee.c: too many arguments to function

