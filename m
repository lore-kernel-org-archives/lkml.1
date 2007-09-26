Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXIZMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXIZMnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXIZMnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 08:43:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46116 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXIZMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:43:34 -0400
Date: Wed, 26 Sep 2007 14:36:57 +0200 (MEST)
Message-Id: <200709261236.l8QCavNM001097@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: balbir@linux.vnet.ibm.com, schwab@suse.de
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print them with %llu macros.
Cc: balbir@in.ibm.com, jlan@engr.sgi.com, linux-kernel@vger.kernel.org,
       muvarov@ru.mvista.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 17:18:06 +0530, Balbir Singh wrote:
> Andreas Schwab wrote:
> > Maxim Uvarov <muvarov@ru.mvista.com> writes:
> > 
> >> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> >> index cbee3a2..73924df 100644
> >> --- a/Documentation/accounting/getdelays.c
> >> +++ b/Documentation/accounting/getdelays.c
> >> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
> >>  void task_context_switch_counts(struct taskstats *t)
> >>  {
> >>  	printf("\n\nTask   %15s%15s\n"
> >> -	       "       %15lu%15lu\n",
> >> +	       "       %15llu%15llu\n",
> >>  	       "voluntary", "nonvoluntary",
> >>  	       t->nvcsw, t->nivcsw);
> > 
> > __u64 is not always long long.
> 
> What is the maximum size of long long across all architectures?
> How does one format __u64 for printing?

With %lu you get warnings when u64 is long long (32-bit).
With %llu you get warnings when u64 is plain long (most 64-bit).

Hence %llu + long long cast, i.e.:
printf("%llu", (unsigned long long)value);

This is ugly but luckily imposes no runtime overheads on
current 32- or 64-bit machines.

This could be done more cleanly if the u64 typedef also
#define:d a corresponding FMT_U64 format string.
