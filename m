Return-Path: <linux-kernel-owner+w=401wt.eu-S937242AbXHHXwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937242AbXHHXwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbXHHXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:52:40 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:3851 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbXHHXwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I4Kz9rVNRmOAezDXyhxjAw9zwVC7Efat3D+AhHnHfhOjvY6vnqSu2e/3w4gc1N8tbc47QPdjdQoYAmiCsaOXA4MjoPdf607K84Ow+DPEY5BaiCvKflQyOuYwE3WFqRHw6sDiDkI5BBxEhvH5kG/1vw/xm87paZeXYN/87RckGQw=
Message-ID: <5ebbd9b50708081652h55c85f9avab4500391c6b7ee0@mail.gmail.com>
Date: Wed, 8 Aug 2007 23:52:37 +0000
From: "Frank Hale" <frankhale@gmail.com>
To: "Joachim Deguara" <joachim.deguara@amd.com>
Subject: Re: ACPI on Averatec 2370
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cal Peake" <cp@absolutedigital.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel ACPI Mailing List" <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200708081642.00581.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
	 <Pine.LNX.4.64.0708071803570.28199@lancer.cnet.absolutedigital.net>
	 <20070808000631.GB7353@one.firstfloor.org>
	 <200708081642.00581.joachim.deguara@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have the latest BIOS update for my laptop which is buggy I suppose.
There has been only one update this year if my memory serves me
correctly. Is there any hope to fix this or am I at the mercy of the
hardware vendor which apparenlty doesn't look like they will release
another patch this year. Please forgive me as I am not a kernel
developer but a concerned user. I've sacrificed ACPI in favor of SMP
at this point, I don't know what it's buying me but the kernel boots
and works fine with the draw back that I have no ACPI and I have to
manually power the computer down by pressing the power button when it
halts. I can live with that if that is the solution but I haven't
really tracked as far as the high level dev stuff goes in this thread
and don't know what the solution might be.

On 8/8/07, Joachim Deguara <joachim.deguara@amd.com> wrote:
> On Wednesday 08 August 2007 02:06:31 Andi Kleen wrote:
> > On Tue, Aug 07, 2007 at 06:15:37PM -0400, Cal Peake wrote:
> > > On Fri, 3 Aug 2007, Linus Torvalds wrote:
> > > > > MSR_K8_ENABLE_C1E lo == 0x04c14015
> > > > > MSR_K8_ENABLE_C1E hi == 0x00000000
> > > > > lo & ENABLE_C1E_MASK == 0
> > > >
> > > > And yeah, that claims that C1E is not on, but:
> > > > > amd_apic_timer_broken: forcing return value of 1
> > >
> > > So it seems my initial debugging report was, err, incomplete. I failed to
> > > notice that the amd_apic_timer_broken function was getting called twice,
> > > once for each core.
> > >
> > > The second call shows this:
> > >
> > >   MSR_K8_ENABLE_C1E == 0x14c14015
> >
> > Ah interesting. Ok finally that all starts making sense.
> >
> > Not sure why the MSR varies between cores though.
>
> This is a BIOS bug as the BIOS should have programmed the MSR the same for
> both cores.  See section 10.2.4 of the Rev F BKDG [1] (10.2.4.1 talks about
> the SMI case but a newer version of the doc not yet release has similar
> wording about both cores needing to have the bit set for the chipset case).
>
> -Joachim
>
> [1]
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
>
>
>
