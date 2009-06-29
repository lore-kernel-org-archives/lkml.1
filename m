Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZF2IWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZF2IWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZF2IV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:21:57 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43880 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZF2IV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a33FG8Gxz7gvmXCY0Ly85YXaTP+ZRLhfAqPW7NaU+ZlJ0iMb+QHkkaH457sDO6rMJs
         77cNHGnA+XCAaCZQAfzzuJSlx2yEEFc9qhGja1dSxCWYPCcA0wJYfWqsVsUVp/Bw8YL5
         9U0Zt355mA3gx+bJcffuv1mhPsb86TQfI4QI4=
MIME-Version: 1.0
In-Reply-To: <20090629081615.GB571@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <20090629072047.GB20225@elte.hu>
	 <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
	 <20090629081615.GB571@elte.hu>
Date: Mon, 29 Jun 2009 16:21:59 +0800
Message-ID: <3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 4:16 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Luming Yu <luming.yu@gmail.com> wrote:
>
>> On Mon, Jun 29, 2009 at 3:20 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >
>> > * Luming Yu <luming.yu@gmail.com> wrote:
>> >
>> >> Hello,
>> >>
>> >> We need to use IPI shortcut to send lapic timer broadcast
>> >> to avoid the latency of sending IPI one bye one on systems with many
>> >> logical processors when NO_HZ is disabled.
>> >> Without this patch,I have seen upstream kernel with RHEL 5 kernel
>> >> config boot hang .
>> >
>> > hm, that might be a valid optimization - but why does the lack of
>> > this optimization result in a hang?
>>
>> It is hang caused by kernel code for work around lapic-timer-stop
>> issue. With HZ=1000, and a lot of cpus (eg. 64 logical cpus), cpu
>> 0 will be busy working on send TIMER IPI instead of making
>> progress in boot (right after deep-C-state has been used).
>
> that's a bit weird. With HZ=1000 we have 1000 usecs between each
> timer tick. Assuming a CPU sends to a lot of CPUs (64 logical CPUs)
> that means that each IPI takes more than ~15 microseconds to
> process. On what hardware/platform can this happen realistically?

https://bugzilla.redhat.com/show_bug.cgi?id=499271

Someone has measured that  it needs 50-100us latency to send one IPI

>
>        Ingo
>
