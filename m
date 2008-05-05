Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbYEEX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbYEEX6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYEEX6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:58:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31401 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbYEEX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:58:13 -0400
Subject: Re: x86: Clean up computation of HPET .mult variables
From: Daniel Walker <dwalker@mvista.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20080505231016.GA29072@beyonder.ift.unesp.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
Content-Type: text/plain
Date: Mon, 05 May 2008 16:58:08 -0700
Message-Id: <1210031888.17132.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 20:11 -0300, Carlos R. Mafra wrote:

> -	tmp = (u64)hpet_period << HPET_SHIFT;
> -	do_div(tmp, FSEC_PER_NSEC);
> -	clocksource_hpet.mult = (u32)tmp;
> +	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
>  

There's helper functions that should be used called clocksource_hz2mult
and one called clocksource_khz2mult. I think they're more accurate than
using div_sc.

Daniel

