Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbYCOEc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbYCOEc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYCOEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:32:20 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:58738 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYCOEcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:32:19 -0400
Date: Sat, 15 Mar 2008 05:28:24 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] split clocksource adjustment from clockosurce mult
In-Reply-To: <1205553938.6122.79.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150526060.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain>
 <1205553938.6122.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> @@ -179,7 +181,7 @@ static inline cycle_t clocksource_read(struct clocksource *cs)
>  static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
>  {
>  	u64 ret = (u64)cycles;
> -	ret = (ret * cs->mult) >> cs->shift;
> +	ret = (ret * (cs->mult + cs->mult_adj)) >> cs->shift;
>  	return ret;
>  }

This add an extra memory access and extra instruction to a code path, we 
should keep as short as possible.
I'd rather add a mult_raw or mult_org and use that for your next patch.

bye, Roman
