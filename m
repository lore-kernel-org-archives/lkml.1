Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbXFWCaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbXFWCaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 22:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXFWCaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 22:30:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:14641 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXFWCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 22:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Agux7v7RexTXh5PSBCHNS3gY6Cs4ByUDzwJv17m9k3CI7vECsMNdiCWnorld5ZlQru0B8dzKl+mTTBI65xgJWbHyQ8ZGcvQfrGR/1haOKXHjRzYiqIT2yywcVuIyfIoMY5MUDlmmkszVQ6voJ0Ja7vVLIg699v7Rql/O44Scs/U=
Message-ID: <787b0d920706221930h11b30ee6mfe10910eaea7467f@mail.gmail.com>
Date: Fri, 22 Jun 2007 22:30:10 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1182523332.2672.14.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <1182447884.2704.7.camel@laptopd505.fenrus.org>
	 <787b0d920706212256u7e78ba6n15ef41bcea99aff0@mail.gmail.com>
	 <1182519821.2672.1.camel@laptopd505.fenrus.org>
	 <787b0d920706220732hef20f67h6b5d1d57db71ead2@mail.gmail.com>
	 <1182523332.2672.14.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Arjan van de Ven <arjan@infradead.org> wrote:

> > > > > and these methods also destroy yourself on any machine with a looser
> > > > > cache coherency between I and D-cache....
> > > > >
> > > > > for all but x86 you pretty much have to do the mprotect() between the
> > > > > two states to deal with the cache flushing properly...
> > > >
> > > > If the instructions to force data write-back and/or to
> > > > invalidate the instruction cache are priveleged, yes.
> > > > AFAIK, only ARM is that lame.
> > >
> > > and your program executes this on all the cpus in the system?
>
> no I meant that you had to call your userspace instruction on all cpus,
> so on all-but-arm (from the Intel side I know IA64 needs such a flush,
> but I'm pretty sure PPC does too)

I understood.

AFAIK, it is common to propagate this via a special
bus cycle. Section 5.1.5.2.1 of the PowerPC manual
states that this is so. Secion 5.1.5.2 lists the requirements
for both uniprocessor and multiprocessor. Note that
Linux uses the coherent memory model for PowerPC SMP.
See also the "icbi" instruction description, where the use
of an address-only broadcast is mentioned.

> > I don't recall seeing such code in the libgcc tranpoline
> > setup for PowerPC. Either it's not required, or this is
> > a rather popular bug.
>
> I suspect it'll be playing under the assumption that going from "no
> code" to "code" is fine since the icache is cold.

A previous trampoline would ruin that.

Fortunately, PowerPC is not as brain-dead as ARM and IA64.
(not that I'm writing code for any of these)
