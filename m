Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYCaCDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYCaCDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYCaCDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:03:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:55981 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755140AbYCaCDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:03:44 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18wM84j9YYwYyDJ2ruF5/jcsFdynY2tZ08wBItp52
	ADOH3IYCsps0X7
Date: Mon, 31 Mar 2008 04:03:41 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc7: warn_on_slowpath triggered
Message-ID: <20080331020341.GB24702@atjola.homenet>
References: <20080329222955.036CCDBA2@gherkin.frus.com> <20080331014037.GA24702@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080331014037.GA24702@atjola.homenet>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.31 03:40:37 +0200, Björn Steinbrink wrote:
> [Added Ingo and Thomas to Cc:]
> 
> On 2008.03.29 17:29:55 -0500, Bob Tracy wrote:
> > System is a AMD K6-III/450.  This is actually a 2.6.25-rcX issue
> > that I'm just getting around to reporting.  Sorry about that...
> 
> Not necessarily a regression, it's just that the WARN_ON_ONCE didn't
> exist yet in 2.6.24.

Hm, the warnings seem to be a bit broken. They were added in
7d409d6057c7244f8757ce15245f6df27271be0c "x86: add some pirq debugging".

In pirq_via586_{get,set} and pirq_ite_{get,set}, they're missing the
fact that we're using pirq-1 to index the array. So it's spitting out
warnings for valid cases. So Bob's warning can very well be completely
bogus.

In pirq_ali_{get,set} there's probably the same problem, but I can't
really tell for sure, because pirq isn't used to index the array
directly, and the comment above that functions tells me not to guess
anything.

For pirq_vlsi_{get,set} I just wondered why that ">= 9" instead of "> 8"
as it is on the next line, but well, that's just style nit-picking...

Björn
