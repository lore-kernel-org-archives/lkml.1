Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYHKUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYHKUEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYHKUEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:04:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:41569 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHKUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qChv0wj3xryBik9Lf3BG9l5qKg+XIHyph8w2aYmrd9TZR3V2KNQIz4A7PpdJd3WQL8
         11k/7VIWPGziUULlDh8jC9ckOOn0CzMi/43Se18uqqN8bFDDq679/Y84p6FR16Vnl+oO
         mfJ2ENyGbvYC3N8eGcZIyVoqEaPAme8Vhtsdg=
Message-ID: <86802c440808111303x16922f43g4e17fa43972e9076@mail.gmail.com>
Date: Mon, 11 Aug 2008 13:03:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Li Zefan" <lizf@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080811195939.GA16716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org>
	 <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com>
	 <b6a2187b0808060833gc9d02caw2893ae8b021d1aa2@mail.gmail.com>
	 <20080811195939.GA16716@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>> On Wed, Aug 6, 2008 at 2:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> > On Wed, Aug 6, 2008 at 2:01 PM, Linus Torvalds
>> > <torvalds@linux-foundation.org> wrote:
>> >> One trivial thing to try would be to just bisect it. I assume 2.6.26 is
>> > Bisecting now.
>>
>> Thanks to all the great helpful suggestions from everyone, and this
>> turns out that I just need to enable the following switches, so I
>> didn't bisect further, and since it's first machine that I've tried
>> with more than 8 CPUs so I wasn't sure whether 2.6.16 has the same
>> problem, but if you wish, I could give 2.6.16 a try.
>>
>> > CONFIG_X86_GENERICARCH=y
>> > CONFIG_X86_BIGSMP=y
>>
>> Thank you all for the great linux kernel!
>
> i still consider a silent boot hang a bug we need to fix.
>
> bigsmp might be required to have all cpus available on your box, but the
> kernel is still supposed to transparently fall back to less CPUs (and
> print a warning) if it cannot do that.
>
in setup.c::setup_arch() after go over with madt or mptable

#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
        if (def_to_bigsmp)
                printk(KERN_WARNING "More than 8 CPUs detected and "
                        "CONFIG_X86_PC cannot handle it.\nUse "
                        "CONFIG_X86_GENERICARCH or
CONFIG_X86_BIGSMP.\n"); ===> here need to change "or" to "and"
#endif

or just panic here? because screen scroll to pass it, and user will
not notice that...

YH
