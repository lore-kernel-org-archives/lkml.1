Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKLR7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKLR7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZKLR7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:59:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZKLR7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:59:20 -0500
Date: Thu, 12 Nov 2009 18:59:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Message-ID: <20091112175908.GB20542@elte.hu>
References: <200911112134.34261.bzolnier@gmail.com>
 <20091112065930.GA9279@elte.hu>
 <4AFBB45A.9000606@zytor.com>
 <20091112081317.GB25345@elte.hu>
 <4AFC274C.2020209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC274C.2020209@zytor.com>
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

> On 11/12/2009 12:13 AM, Ingo Molnar wrote:
> >>
> >> /proc/cpuinfo is a user-space visible ABI.  Changing it is bad 
> >> chicken.
> > 
> > Almost ... something is only an ABI if an actual application relies on 
> > the 'ht' flag being there on non-hyperthreading CPUs. We dont know 
> > whether there's any, but the likelyhood looks pretty low. Could park it 
> > a branch for some time to see whether anything trips up.
> > 
> 
> No, please.  We have had people who have "helpfully" tried to change 
> /proc/cpuinfo in the past, and what we find is that application 
> developers don't tell us -- they grumble among themselves and put out 
> a new release saying "fixes breakage introduced by Linux ..."
> 
> It's an ABI.  Keep it stable, please.

That's generally true, but i'm not suggesting that: i'm suggesting to 
_clear_ the HT flag from the cpufeatures if there's only one sibling. 
It's meaningless in that case and as the link quoted by the original 
patch shows many people are confused by that.

I have such a box so i can test it. (but i dont expect any problems)

	Ingo
