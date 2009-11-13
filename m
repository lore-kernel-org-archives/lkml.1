Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZKMHnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZKMHnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZKMHm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:42:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZKMHm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:42:58 -0500
Date: Fri, 13 Nov 2009 08:42:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Message-ID: <20091113074248.GA2775@elte.hu>
References: <200911112134.34261.bzolnier@gmail.com>
 <20091112065930.GA9279@elte.hu>
 <4AFBB45A.9000606@zytor.com>
 <20091112081317.GB25345@elte.hu>
 <4AFC274C.2020209@zytor.com>
 <20091112175908.GB20542@elte.hu>
 <20091112183718.GA1925@codemonkey.org.uk>
 <4AFC66E7.5040900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC66E7.5040900@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/12/2009 10:37 AM, Dave Jones wrote:
> > On Thu, Nov 12, 2009 at 06:59:08PM +0100, Ingo Molnar wrote:
> >  > > It's an ABI.  Keep it stable, please.
> >  > 
> >  > That's generally true, but i'm not suggesting that: i'm suggesting to 
> >  > _clear_ the HT flag from the cpufeatures if there's only one sibling. 
> >  > It's meaningless in that case and as the link quoted by the original 
> >  > patch shows many people are confused by that.
> >  > 
> >  > I have such a box so i can test it. (but i dont expect any problems)
> > 
> > I agree that it's an ABI change, but any software depending on its current
> > state has to implement a fallback for the case where 'ht' isn't present anyway
> > unless there's some program that only runs on ht capable hardware, which
> > sounds just crazy.
> > 
> > The only potential for breakage that I can see is that code that is tuned
> > to be run in the HT case will stop running in cases where it shouldn't.
> > Which sounds like a positive thing to me.
> 
> The most likely breakage would be some stupid licensing scheme.
> 
> The other aspect is that we as much as possible have tried to stay to 
> the hardware-documented names of these strings.  Inventing new strings 
> is generally a bad idea.

Agreed - and we rejected such patches a couple of times in the past and 
for good reasons. Some /proc details are rarely used by apps (so they 
are no real ABIs) but cpuinfo is frequently parsed.

Clearing the ht flag on non-hyperthreading CPUs would be a limited 
quirk/fix in essence applicable to a relatively narrow range of CPUs - 
and easily undone, should it cause any problems. So if Bart wants to 
take a stab at that it would be a nice solution to the problem at hand 
...

	Ingo
