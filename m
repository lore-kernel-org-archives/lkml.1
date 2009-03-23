Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZCWK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZCWK5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZCWK5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:57:15 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35817 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZCWK5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xRPTd1KUHRG4kR11ldMhiKLiNhDT1K/JKeUD0cOwHrDIRYVxwWjij/tqQybj+cdSzb
         RuyFDGzopiHrRuzq8WkLELlSyW2JPK2nzbqKuqLh1bQtAJYI3DYSMdFkkk0Iq4KKQGiM
         BvNT3mpt7AdGNBlWHwy3y2ix5fzrYiJ3vLm2E=
MIME-Version: 1.0
In-Reply-To: <20090321014909.6b654f55.akpm@linux-foundation.org>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	 <20090321014140.AA4F5FC3AB@magilla.sf.frob.com>
	 <20090321014909.6b654f55.akpm@linux-foundation.org>
Date: Mon, 23 Mar 2009 10:57:11 +0000
Message-ID: <87a5b0800903230357n3eedaac1u6c70c22fedea5ffc@mail.gmail.com>
Subject: Re: [PATCH 2/3] utrace core
From: Will Newton <will.newton@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 8:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 20 Mar 2009 18:41:40 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:
>
>> This adds the utrace facility, a new modular interface in the kernel for
>> implementing user thread tracing and debugging.  This fits on top of the
>> tracehook_* layer, so the new code is well-isolated.
>>
>> The new interface is in <linux/utrace.h> and the DocBook utrace book
>> describes it.  It allows for multiple separate tracing engines to work in
>> parallel without interfering with each other.  Higher-level tracing
>> facilities can be implemented as loadable kernel modules using this layer.
>>
>> The new facility is made optional under CONFIG_UTRACE.
>> When this is not enabled, no new code is added.
>> It can only be enabled on machines that have all the
>> prerequisites and select CONFIG_HAVE_ARCH_TRACEHOOK.
>>
>> In this initial version, utrace and ptrace do not play together at all.
>> If ptrace is attached to a thread, the attach calls in the utrace kernel
>> API return -EBUSY.  If utrace is attached to a thread, the PTRACE_ATTACH
>> or PTRACE_TRACEME request will return EBUSY to userland.  The old ptrace
>> code is otherwise unchanged and nothing using ptrace should be affected
>> by this patch as long as utrace is not used at the same time.  In the
>> future we can clean up the ptrace implementation and rework it to use
>> the utrace API.
>
> I'd be interested in seeing a bit of discussion regarding the overall value
> of utrace - it has been quite a while since it floated past.
>
> I assume that redoing ptrace to be a client of utrace _will_ happen, and
> that this is merely a cleanup exercise with no new user-visible features?
>
> The "prototype utrace-ftrace interface" seems to be more a cool toy rather
> than a serious new kernel feature (yes?)
>
> If so, what are the new killer utrace clients which would justify all these
> changes?

It looks like utrace could provide a nice way to do low latency
tracing of userspace processes via a hardware interface (e.g. JTAG or
custom trace hardware). The only way to do that at present is to
scatter bits of instrumentation throughout the kernel.

I would like to see utrace merged so I can work on that type of feature.
