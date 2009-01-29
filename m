Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZA2OCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZA2OCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZA2OCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:02:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZA2OCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:02:40 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old subarchitecture code
From: Andi Kleen <andi@firstfloor.org>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
Date: Thu, 29 Jan 2009 15:02:10 +0100
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu> (Ingo Molnar's message of "Wed, 28 Jan 2009 23:41:06 +0000")
Message-ID: <87vdryw6ql.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> So breakages are to be expected. The commits are queued up in
> tip/x86/apic and are in tip/master as well:
>
>     http://people.redhat.com/mingo/tip.git/README

I haven't read it all, but the stuff I looked at looked
all reasonable and indeed cleaned up the 32bit code significantly
(and be neutral on 64bit). Thanks for doing that work.

My suggestion would be to deprecate and then remove es7000 and
numaq too. The es7000 subarch is only for very old es7000 systems (the
newer ones all work with bigsmp) and I expect the user base is very
likely zero or very near it. For NUMAQ it's similar -- there's
apparently one system left at IBM, and I'm sure IBM can find some
replacement. Especially NUMAQ has some ugly ifdefery outside the
subarch code too that would be good to remove. Overall that would
be a good cleanup without impacting the user base really.

Also bigsmp is kind of obsolete too, it could be probably
merged with default with very tiny impact because it's not
all that different.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
