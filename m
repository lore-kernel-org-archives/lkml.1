Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYFJUno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYFJUno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYFJUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:43:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:60473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYFJUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,619,1204531200"; 
   d="scan'208";a="290867510"
Message-ID: <484EE71A.40002@intel.com>
Date: Tue, 10 Jun 2008 13:42:02 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
References: <200806102152.23286.solstice.dhiver@gmail.com> <20080610131314.5f7069e6@infradead.org>
In-Reply-To: <20080610131314.5f7069e6@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 20:43:06.0692 (UTC) FILETIME=[961A8040:01C8CB3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 10 Jun 2008 21:52:23 +0200
> solsTiCe d'Hiver <solstice.dhiver@gmail.com> wrote:
> 
>> hi,
>>
>> i am running a 2.6.25.5-rt6 kernel.
>> i know there is no such thing as 2.6.25.5-rt6 yet. so i have checked
>> with a 2.6.25.4-rt6 kernel and i have the same issue.
>>
>> when i try to run jackd (0.109.2) i get that strange error:
>> FATAL: cannot locate cpu MHz in /proc/cpuinfo
>>
>> and it appears that /proc/cpuinfo lack the line 
>> cpu MHz:
> 
> 
> btw this is scary; the Mhz line in /proc/cpuinfo doesn't have much
> meaning really, so applications using it and depending on it is a
> rather big disaster ;-(
> 
> Does anyone know why jackd wants to use this?

I just poked into Jackd and it seems to be using fallback code to calculate timing
intervals from the cpu MHz value (config/os/gnu-linux/time.c).

the code itself is self-addmittedly a kludge:


122 /*
123  * This is another kludge.  It looks CPU-dependent, but actually it
124  * reflects the lack of standards for the Linux kernel formatting of
125  * /proc/cpuinfo.
126  */
127
128 jack_time_t
129 jack_get_mhz (void)
130 {
131         FILE *f = fopen("/proc/cpuinfo", "r");

one kludge building on another :)


Auke

