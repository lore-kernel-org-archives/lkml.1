Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZAXBgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZAXBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 20:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZAXBgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 20:36:32 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:47492 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZAXBgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 20:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xo1TGTZ1ManOp3ku+m5l181gdGPS4pPt0lcBHrwYxhEJyWqT4BeCdOSXO1is51kybL
         SQ9f/tGlbooYpqAaT+dYpYlqhMVGoVE1p7gUZIe+uaUEZwvMDtxXTfYVLqNCCSNNoOjM
         eN1pOiHd6vhKEpcWr6mmPTalRvdj1WnJcTqqo=
MIME-Version: 1.0
In-Reply-To: <20090123110439.GK15188@elte.hu>
References: <20090121171423.GI21473@genesis.frugalware.org>
	 <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com>
	 <20090121210726.GK21473@genesis.frugalware.org>
	 <1232573646.6997.21.camel@localhost.localdomain>
	 <20090122195132.GZ21473@genesis.frugalware.org>
	 <20090122235727.GB21473@genesis.frugalware.org>
	 <1232674994.6678.45.camel@localhost.localdomain>
	 <20090123110439.GK15188@elte.hu>
Date: Fri, 23 Jan 2009 17:36:30 -0800
X-Google-Sender-Auth: 79b23a71d6f2dc7e
Message-ID: <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Miklos Vajna <vmiklos@frugalware.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?ISO-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
>> I'd think this would ideally be more of a subarch in the config
>> selection like the AMD Elan is, so folks know it really is not just a
>> extra-support feature and in fact limits what hardware you can use the
>> resulting kernel on.
>
> a better solution is that if RDC is set [it is unset by default] we should
> turn PIT_TICK_RATE into a variable, defaulting it to 1193182. If a real
> RDC or ELAN system is running, that variable is changed during early
> bootup, in the init functions for those platforms.

Took a quick look at this, and I don't see any detection code for
either RDC. The X86_ELAN config also has no conditionals, but maybe
the elan cpufreq code can help here.

Florian: Is there any way we can check very early (ie: in setup_arch)
for an RDC box?

Robert Schwebel, Sven Geggus: Either of you still maintaining the ELAN
code?  Will the following from elanfreq_cpu_init catch all ELAN chips?

        if ((c->x86_vendor != X86_VENDOR_AMD) ||
            (c->x86 != 4) || (c->x86_model != 10))


thanks
-john
