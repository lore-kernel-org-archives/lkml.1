Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbYARTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbYARTYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYARTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:24:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbYARTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:24:08 -0500
Date: Fri, 18 Jan 2008 11:23:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Mel Gorman <mel@csn.ul.ie>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Mike Snitzer <snitzer@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       jplatte@naasa.net, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       James.Bottomley@steeleye.com
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
In-Reply-To: <903015.63912.qm@web32611.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.00.0801181109410.2957@woody.linux-foundation.org>
References: <903015.63912.qm@web32611.mail.mud.yahoo.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Martin Knoblauch wrote:
>
>  just to make one thing clear - I am not so much concerned about the
> performance of AACRAID. It is OK with or without Mel's patch. It is
> better with Mel's patch. The regression in DIO compared to 2.6.19.2 is
> completely independent of Mel's stuff.
> 
>  What interests me much more is the behaviour of the CCISS+LVM based
> system. Here I see a huge benefit of reverting Mel's patch.

Ok, I just got your usage cases confused.

The argument stays the same: some controllers/drivers may have subtle 
behavioural differences that come from the IO limits themselves.

So it wasn't AACRAID, it was CCISS+LVM. The argument is the same: it may 
well be that the *bigger* IO sizes are actually what hurts, even if the 
conventional wisdom is traditionally that bigger submissions are better.

>  At least, rc1-rc5 have shown that the CCISS system can do well. Now
> the question is which part of the system does not cope well with the
> larger IO sizes? Is it the CCISS controller, LVM or both. I am open to
> suggestions on how to debug that. 

I think you need to ask the MD/DM people for suggestions.. Who aren't cc'd 
here.

		Linus
