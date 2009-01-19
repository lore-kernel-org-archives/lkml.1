Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbZASNWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbZASNWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZASNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:22:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZASNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:22:35 -0500
Date: Mon, 19 Jan 2009 14:22:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
Message-ID: <20090119132214.GA20722@elte.hu>
References: <1232370050-7434-1-git-send-email-avi@redhat.com> <20090119130927.GC6876@elte.hu> <49747C44.1030901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49747C44.1030901@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Avi Kivity <avi@redhat.com> wrote:
>>
>>   
>>> Kconfig symbols are not available in userspace, and are not stripped by
>>> headers-install.  Avoid their use by adding #defines in <asm/kvm.h> to
>>> suit each architecture.
>>>
>>>     
>> looks good - you will push this via the KVM tree, right?
>>   
>
> Yes.  Thanks for the review.

btw., would be nice to somehow untangle consciously-exported interface 
definitions from kernel side bits, and standardize these 
feature/capability flags like __KVM_HAVE_IOAPIC, etc.

Right now we have this body of 75,000 lines of code spread out in 600+ 
header files that are so-called 'exported' to user-space, but 95% of that 
interface definition code is never being relied on by any user-space bit! 
They are exported due to cargo-cult mentality or due to dependencies.

It would be far better to have an explicit place for such bits, 
include/syscall-ABI/ or so - and not export _any_ other kernel headers. 
But that's a much larger project.

	Ingo
