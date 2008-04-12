Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYDLNnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYDLNnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 09:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYDLNm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 09:42:56 -0400
Received: from gherkin.frus.com ([192.158.254.49]:54384 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbYDLNm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 09:42:56 -0400
Subject: Re: 2.6.25-rc7: warn_on_slowpath triggered
In-Reply-To: <20080331020341.GB24702@atjola.homenet> =?ISO-8859-1?Q?from_Bj=F6rn_Steinbrink_at_Mar_31=2C_2008_04=3A03=3A41_am?=
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Date: Sat, 12 Apr 2008 08:42:49 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UNKNOWN-8BIT
Message-Id: <20080412134249.E3A0FDBA4@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> On 2008.03.31 03:40:37 +0200, Bj?rn Steinbrink wrote:
> > [Added Ingo and Thomas to Cc:]
> > 
> > On 2008.03.29 17:29:55 -0500, Bob Tracy wrote:
> > > System is a AMD K6-III/450.  This is actually a 2.6.25-rcX issue
> > > that I'm just getting around to reporting.  Sorry about that...
> > 
> > Not necessarily a regression, it's just that the WARN_ON_ONCE didn't
> > exist yet in 2.6.24.
> 
> Hm, the warnings seem to be a bit broken. They were added in
> 7d409d6057c7244f8757ce15245f6df27271be0c "x86: add some pirq debugging".
> 
> In pirq_via586_{get,set} and pirq_ite_{get,set}, they're missing the
> fact that we're using pirq-1 to index the array. So it's spitting out
> warnings for valid cases. So Bob's warning can very well be completely
> bogus.
> 
> In pirq_ali_{get,set} there's probably the same problem, but I can't
> really tell for sure, because pirq isn't used to index the array
> directly, and the comment above that functions tells me not to guess
> anything.
> 
> For pirq_vlsi_{get,set} I just wondered why that ">= 9" instead of "> 8"
> as it is on the next line, but well, that's just style nit-picking...
> 
> Bj?rn

I've been out of town for the past week and a half, and had no way to
test the "linux/arch/x86/pci/irq.c" patch you provided.  Since this is
still being tracked as an unresolved issue, I guess I need to say "it
fixes the problem for me." Your fix didn't make it into mainline for
2.6.25-rc8, but it applies cleanly and works properly there as well.

Thanks!

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
