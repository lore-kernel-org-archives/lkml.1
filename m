Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYDSCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYDSCQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYDSCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:15:54 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:57085 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbYDSCPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:15:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Yinghai Lu <yhlu.kernel.send@gmail.com>
Subject: Re: [PATCH] x86_64: simplify the memtest parameter setting
Date: Sat, 19 Apr 2008 04:15:46 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, akpm@linux-foundation.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
References: <200804181749.15782.yhlu.kernel@gmail.com> <200804190357.09243.elendil@planet.nl>
In-Reply-To: <200804190357.09243.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804190415.47552.elendil@planet.nl>
X-OriginalArrivalTime: 19 Apr 2008 02:15:50.0051 (UTC) FILETIME=[494C9730:01C8A1C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008, Frans Pop wrote:
> Yinghai Lu wrote:
> > -config MEMTEST_BOOTPARAM
> > -	bool "Memtest boot parameter"
> > +config MEMTEST
> > +	bool "Memtest"
> >  depends on X86_64
> >  default y
>
> With this patch, this default no longer makes any sense.
>
> >  help
> >  This option adds a kernel parameter 'memtest', which allows memtest
> > -	  to be disabled at boot.  If this option is selected, memtest
> > -	  functionality can be disabled with memtest=0 on the kernel
> > -	  command line.  The purpose of this option is to allow a single
> > -	  kernel image to be distributed with memtest built in, but not
> > -	  necessarily enabled.
> > -
> > +	  to be set.
> > +		memtest=0, mean disabled; -- default
> > +		memtest=1, mean do 1 test pattern;
> > +		...
> > +		memtest=4, mean do 4 test patterns.
>
> s/mean/means/
> s/; -- default/ (default)/

These are still good (IMO).

> Maybe some explanation of what a "test pattern" is would be useful.
>
> >  If you are unsure how to answer this question, answer Y.
>
> Also makes no sense anymore.

Oops. Just see I was too fast. After reading it again I see that the y/n 
value is correct after all.

However, it also means that the new description is probably too short.
The phrase "allows memtest to be set" does not really mean anything to a 
user who does not know what memtest really does. It also does not explain 
that memtest is a boot parameter.

Also, it should probably be made more explicit that no memtest is actually 
performed unless the memtest boot parameter is passed at the boot prompt.

Looks like 4 is the maximum possible value. This should be mentioned 
explicitly (here as well as in Documentation/kernel-parameters.txt).

Maybe something like this:
	This option allows a memory test to be executed when the system is
	booted. A memory test is only actually executed if the kernel boot
	parameter 'memtest' is passed.

	The value of that parameter is the number to times the test is
	performed:
		memtest=0: don't perform the test (default)
		memtest=1: perform the test once
		...
		memtest=4: perform the test 4 times (maximum).

	If you are unsure how to answer this question, answer Y.

Hmmm. The original description mentions "N patterns". If those patterns are 
actually different, then a different description is probably needed.

Sorry for the confusion.

Cheers,
FJP
