Return-Path: <linux-kernel-owner+w=401wt.eu-S966044AbZLHU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966044AbZLHU0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966015AbZLHU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:26:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:36582 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965996AbZLHU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RESGKbJDy0LGxaXkq9tBENtDN/UErFMAIZttUM39NzEIzBw/Cj0fmcZ6KPUvIRPYfZ
         gZn6EdMPhI8NKsxMF+Fqa/lUxSnI4ZLma2Tcd1Jlcpe/Uxi6ixclm7jSolbX6EMaNbuj
         GUTBtcCdSftaJXgsP0Letbfymqh0qnmjUmLmI=
Date: Tue, 8 Dec 2009 23:26:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@elte.hu, macro@linux-mips.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86,apic: Use logical OR in noop-write operation
Message-ID: <20091208202606.GA4780@lenovo>
References: <20091208155316.561853924@openvz.org> <20091208155557.326359748@openvz.org> <4B1EB2B0.4000204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1EB2B0.4000204@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 12:10:24PM -0800, H. Peter Anvin wrote:
> On 12/08/2009 07:53 AM, Cyrill Gorcunov wrote:
> > For apic noop'ified we have to use logical OR statement,
> > otherwise any write on systems shipped with 82489DX
> > (where apic presence bit can't be retrieved via cpuid)
> > will not trigger the warning which is not desired.
> > 
> > In turn noop'ified read operation remains using logical
> > AND statement. This will catch _only_ future code bugs
> > since:
> > 
> > 1) The old 32bit systems without apic presence bit use
> >    disable_apic only as a flag that chip was turned off
> >    via boot option but not due to MP-table (BIOS) bug where
> >    we may try to re-enable apic via MSR registers. The further
> >    SMP setup code already prepared for a such situation
> >    (ie it disables SMP support) and do not issue write
> >    operations but still needs to issue apic_read. So instead
> >    of deforming code with "if" we just allow reads until
> >    SMP support gets disabled. But even then we still need
> >    apic_read issued on a such machine at shutdown procedure.
> > 
> > 2) x86-64 at moment properly uses cpu_has_apic and turn
> >    this feature off as only chip is disabled together
> >    with disable_apic flag.
> > 
> 
> Could you clarify the question I asked yesterday: how is the "or"
> different from just warning unconditionally (which would at least be a
> lot more clear)?

Hmm, indeed it seems that unconditional WARN would be more clean
and reliable. Will recheck all apic_write calls.

> Can the situation that !cpu_has_apic && disable_apic
> actually happen and we *still* end up in apic_write?

No, this situation should not take place as far as I remember.

> 
> 	-hpa
> 
	-- Cyrill
