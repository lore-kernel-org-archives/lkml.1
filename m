Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0BROBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:01:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42232 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0BROBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:01:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nJOMzfeK1mCC+N/HUaOvlJygfLSQFcv4ZyjJ2fl0gHRSIPgYE8n9nU0h4xuNHqIkuG
         PBX5DjEqd1OPbiOj6WrM/ItmWmDTiog1CAD2SgSrLAc3N4tEmi3P0mDIWAF2/18gy7lt
         eldmGCyNA+hdKGyFgpnZ4IN2x5HRsJi9UDnbs=
MIME-Version: 1.0
In-Reply-To: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> 
	<1266491616-6270-3-git-send-regression-fweisbec@gmail.com> 
	<8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> 
	<20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> 
	<20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Feb 2010 09:01:12 -0500
Message-ID: <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 08:25, Heiko Carstens wrote:
> On Thu, Feb 18, 2010 at 01:34:57PM +0100, Frederic Weisbecker wrote:
>> On Thu, Feb 18, 2010 at 07:12:08AM -0500, Mike Frysinger wrote:
>> > On Thu, Feb 18, 2010 at 07:09, Heiko Carstens wrote:
>> > > On Thu, Feb 18, 2010 at 06:18:20AM -0500, Mike Frysinger wrote:
>> > >> On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
>> > >> > --- a/arch/Kconfig
>> > >> > +++ b/arch/Kconfig
>> > >> > @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
>> > >> >  config USE_GENERIC_SMP_HELPERS
>> > >> >        bool
>> > >> >
>> > >> > +config HAVE_REGS_AND_STACK_ACCESS_API
>> > >> > +       bool
>> > >> > +
>> > >>
>> > >> could you add an appropriate help/comment so arch peeps know what
>> > >> needs to be implemented before they can select this
>> > >
>> > > That's why I added the commit ID for the regs and stack access api
>> > > to the changelog. imho that should be sufficient.
>> > > Besides that the next commit would implement it for s390 as a
>> > > blueprint for others. That is... for those that missed the initial
>> > > x86 implementation.
>> >
>> > people shouldnt have to dive into the changelog to try and divine
>> > documentation.  it's hardly standard, so people fall on it in a
>> > pima-last-resort kind of way.  being explicit in the file up front by
>> > writing real documentation says other people a lot more time.
>> > -mike
>>
>>
>> Yeah, would be nice to have a comment above the config definition
>> to explain what it implies.
>>
>> Heiko, mind sending a delta patch for that?
>
> Subject: [PATCH] tracing/kprobes: add short documentation for HAVE_REGS_AND_STACK_ACCESS_API
>
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
>
>  config HAVE_REGS_AND_STACK_ACCESS_API
>        bool
> +       help
> +         This symbol should be selected by an architecure if it supports
> +         the API needed to access registers and stack entries from pt_regs.
> +         For example the kprobes-based event tracer needs this API.

a bit vague ... arent there headers/functions people could look at ?
perhaps you're talking about the regset functions (which is an API to
access registers in pt_regs) ?  or you're talking about asm/syscall.h
(which is an API to access registers in pt_regs) ?

i'm not asking to be a pain, i'm asking because i really havent a
clue.  if i wanted to add support for this stuff to the Blackfin arch,
i wouldnt know where to start.  even after reading this help i'd fall
back to grepping arch/x86/ and trying to divine a starting point from
there.
-mike
