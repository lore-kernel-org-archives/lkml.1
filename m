Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZIHHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZIHHtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZIHHtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:49:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:55876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZIHHtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:49:16 -0400
Date: Tue, 8 Sep 2009 00:52:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
Message-ID: <20090908005236.1fbfdd13@infradead.org>
In-Reply-To: <3877989d0909072209g454d92feuc0d3cdbd95a13a9c@mail.gmail.com>
References: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
	<20090907204913.2aef5c49@infradead.org>
	<3877989d0909072209g454d92feuc0d3cdbd95a13a9c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 13:09:44 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> On Tue, Sep 8, 2009 at 11:49 AM, Arjan van de
> Ven<arjan@infradead.org> wrote:
> > On Tue, 8 Sep 2009 10:26:06 +0800
> > Luming Yu <luming.yu@gmail.com> wrote:
> >
> >> Hi there,
> >>
> >> I came across acpi_idle_enter_simple, noticed it looks like a bug
> >> if we don't flush cache for C2.
> >> Because some platforms just map C2 to C3.
> >
> > I think you are confusing ACPI C3 with HW C3.
> >
> > Only for ACPI C3 class do you need to flush the cache for this case.
> > For HW C3, if you would need to flush the cache, the BIOS would
> > assign it ACPI C3 class.
> >
> 
> There is no confusion,I just extend the existing kernel logic as below
> to cover cache flush..
> 
> "
> "/*
>  * Some BIOS implementations switch to C3 in the published C2 state.
>  * This seems to be a common problem on AMD boxen, but other vendors
>  * are affected too. We pick the most conservative approach: we assume
>  * that the local APIC stops in both C2 and C3.
>  */
> static void lapic_timer_check_state
> 
> "

unlike lapic behavior, the cache flush behavior is very explicit in the
ACPI spec. In fact, it is the DEFINITION of ACPI C3. Local apic
behavior otoh isn't anywhere near the acpi spec in this regard.
(yes I know of the value of specs, but this one is rather clear).

Do you have an example of a specific machine where this is fscked up? 
(if so, it's blacklist worthy.. probably worth blacklisting just
outright doing C states on it)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
