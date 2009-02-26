Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZBZEEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZBZEEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBZEEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:04:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:38891 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZBZEEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SXMByjkMJEQ+BwAg17dlrdQ1k0tpErFqF/21+JtUqqToM1Rk1J9YoT6X/u1oR6c6X9
         JUL2chN+P42tRCFEV1t2zsyFxmOTRJvbezdiVWYzX8aN4FA9T2by3+6YEsrB6nGxhcAW
         /bW7CtRkefs8gDI5qu8kQdK+aJXWX9lhHQOwk=
MIME-Version: 1.0
In-Reply-To: <20090226032544.GB22223@elte.hu>
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu>
	 <1235617541.5610.0.camel@brick> <20090226031301.GE7526@elte.hu>
	 <1235618574.5610.1.camel@brick> <20090226032544.GB22223@elte.hu>
Date: Thu, 26 Feb 2009 07:04:27 +0300
Message-ID: <aa79d98a0902252004n2d9d06fcpf2b2ff20f1c8442a@mail.gmail.com>
Subject: Re: [RFC] introduce pr_cont macro
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
>> On Thu, 2009-02-26 at 04:13 +0100, Ingo Molnar wrote:
>> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
>> >
>> > > On Thu, 2009-02-26 at 04:03 +0100, Ingo Molnar wrote:
>> > > > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > > >
>> > > > > We cover all log-levels by pr_... macros except
>> > > > > KERN_CONT one. Add it for convenience.
>> > > > >
>> > > > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> > > > > ---
>> > > > >
>> > > > > I think start printing with some pr_... macro
>> > > > > and continue with printk(KERN_CONT ...) look
>> > > > > not that clear -- better to continue with
>> > > > > same pr_... slogan. Thoughts? I hope I didn't
>> > > > > miss anything.
>> > > > >
>> > > > >  include/linux/kernel.h |    2 ++
>> > > > >  1 file changed, 2 insertions(+)
>> > > > >
>> > > > > Index: linux-2.6.git/include/linux/kernel.h
>> > > > > ===================================================================
>> > > > > --- linux-2.6.git.orig/include/linux/kernel.h
>> > > > > +++ linux-2.6.git/include/linux/kernel.h
>> > > > > @@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
>> > > > >          printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
>> > > > >  #define pr_info(fmt, ...) \
>> > > > >          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>> > > > > +#define pr_cont(fmt, ...) \
>> > > > > +        printk(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
>> > > >
>> > > > Makes sense.
>> > > >
>> > > > Acked-by: Ingo Molnar <mingo@elte.hu>
>> > > >
>> > >
>> > > Don't you want to omit the pr_fmt() from the KERN_CONT case?
>> >
>> > indeed, good catch. It should be:
>> >
>> > #define pr_cont(fmt, ...) \
>> > 	printk(KERN_CONT ##__VA_ARGS__)
>>
>> Missing fmt entirely?
>
> yeah ...
>
> Btw., why do those macros use ##__VA_ARGS__ ? Why not a
> straightforward:
>
>  #define __pr_cont(args...) \
>  	printk(KERN_CONT args)
>
> ?
>
> 	Ingo

Grr... Thanks for catching me! Ingo, Harvey could you drop this patch
and make new one in good shape?
