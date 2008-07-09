Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYGINOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYGINOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYGINOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:14:07 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:32190 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYGINOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:14:05 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-37.messagelabs.com!1215609243!4819452!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 9 Jul 2008 15:13:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080709131353.GA12009@digi.com>
References: <20080625131101.GA6205@digi.com> <20080704104634.GA31634@digi.com> <20080704101717.28f6a771.akpm@linux-foundation.org> <20080704184307.GA8076@digi.com> <20080704120837.573adc9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704120837.573adc9c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jul 2008 13:13:53.0287 (UTC) FILETIME=[A29A0970:01C8E1C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 4 Jul 2008 20:43:07 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:
> 
> > >                                            I wonder if we can do better.
> > > Let me think about that.
> > I was about to suggest something like:
> >
> >       /* WARNING: this returns a static pointer, so you cannot use the
> >        * returned value after another call to creative_function_name
> >        */
> >       char *creative_function_name(void *addr)
> >       {
> >               static char buf[SOME_LENGTH];
> >
> >               ... format symbol name into buf ...
> >
> >               return buf;
> >       }
> >
> > Then I could have used
> >
> >       pr_err("setting flow type for irq %u failed (%s)\n",
> >                       irq, creative_function_name(chip->set_type));
> >
> > which looks definitely nicer.
> 
> Better would be
> 
>         char buf[ENOUGH /* rofl */];
> 
>         pr_err("setting flow type for irq %u failed (%s)\n",
>                         irq, render_function_name(buf, chip->set_type));
> 
> However I'm presently brewing up a plot to do this:
> 
>         printk("function name is %Ss\n", (unsigned long *)chip->set_type);
> 
> which I think will work.  We can also do
> 
>         printk("IP address is %Si\n", (unsigned long *)ip_address_buffer);
> 
> to replace NIPQUAD.  And similar printk extensions.
> 
> Am still thinking about it though.
I assume the result is 0fe1ef24f7bd0020f29ffe287dfdb9ead33ca0b2?

Should I send a new version using %pF or is it easier if you fix up the
patch?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
