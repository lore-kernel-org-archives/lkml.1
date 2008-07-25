Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYGYM3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYGYM3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYGYM3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:29:25 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:51863 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbYGYM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:29:25 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fqcXAbQVtz86iDzGxlJRSCOQOyHej7G2k6tsw6gvBT8Y4pudxuPdFm3H
   CBeTi2A9zbWELnZF8ihgCEvmcUN9A/1rri8pTr8ZfHNVauZdr9jYh1/1s
   9g98DNXqyDSrzFN;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="21211284"
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="32947002"
Message-ID: <4889C723.7050402@fujitsu-siemens.com>
Date: Fri, 25 Jul 2008 14:29:23 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take
 2)
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo>
In-Reply-To: <20080725100844.GA16698@lenovo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> Hi Martin, what about the patch below - I simplified it a bit.
> Actually we have to handle 32bit mode as well I think.

Yes.

> Anyway,
> take a look. I don't really mind against your patch but we better
> should wait until Maciej could take a look (he will be able in
> a week or maybe a bit later).
> 

> +       for (i = 0; i < MAX_ITER; i++) {
> +               rdtscll(tsc0);
> +               *apic = apic_read(APIC_TMCCT);
> +               rdtscll(tsc1);
> +               diff = tsc1 - tsc0;
> +               if (diff < MAX_DIFFERENCE) {
> +                       *tsc = tsc0 + diff / 2;
> +                       return 0;
> +               }
> +       }
 > +
 > +       return -EIO ;

This is wrong - you need to set *tsc also in the -EIO case, otherwise 
the function can return total bogus.

I have to say that my simplified patch failed to do the calibration 
correctly on our test system (the original patch worked well). Please 
stay tuned, we are investigating this currently.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
