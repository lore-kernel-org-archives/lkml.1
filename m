Return-Path: <linux-kernel-owner+w=401wt.eu-S1759869AbYHOOpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869AbYHOOpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYHOOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:45:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:51212 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYHOOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lIHG+o0Rq0msVbAHM0KduNubAps/G7dLnwlLl17AOhe5+KqfJpoqvzlDEDHrNIXNyJ
         Igps15GmY1e5hV65iDETcsG8vr13X2J1ZY+lTtjd72AgVGEhss15pMAXPupKoNJAkRKm
         b8ZiaHZRVrBvQNM5aSqfhel2vewa5XphIhnms=
Date: Fri, 15 Aug 2008 18:45:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, tglx@linutronix.de,
       hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Message-ID: <20080815144509.GA7178@lenovo>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com> <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl> <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com> <20080815115147.GA32726@elte.hu> <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl> <20080815134801.GA14103@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815134801.GA14103@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Aug 15, 2008 at 03:48:01PM +0200]
| 
| * Maciej W. Rozycki <macro@linux-mips.org> wrote:
| 
| > > If that was the question, the answer would be: to unify apic_32.c 
| > > and apic_64.c we first use tiny little changes to bring the two 
| > > files in sync. Presumably, each such change is a NOP or at least 
| > > very safe - and clearly bisectable in the worst-case.
| > 
| >  If the obfuscation comes from apic_64.c, then the clean-up should be 
| > done in th other direction IMO.  Not everything that comes from the 
| > 64-bit variation is better than its 32-bit counterpart.
| 
| yeah - in fact for most unifications we did the 32-bit counterpart was 
| the cleaner one. (which is no big surprise, 80%-90% of the x86 Linux 
| use, even today, is on the 32-bit side - so most developers watch that 
| one.)
| 
| 	Ingo
| 

Thanks you both for review and comments!

Since lapic_is_integrated is just eliminated on 64bit I thought
it's better to have smooth code flow as much as possible. By 'smooth'
I mean to not use #ifdef until there is no chance to escape from.

I think I'll send next series if only merging procedure will be
completed.

And Maciej - you're so right - if someone will take a look on the
apic_64.c code now he will be quite wondered what lapic_is_integrated
is doing in 64bit code.

Ingo, I don't know but maybe you should drop the patches I sent since
they could (espec the snippet Maciej pointed to) confuse code reader
(sine merging process is not completed yet). Sorry for incovenience
and thanks again for review!

		- Cyrill -
