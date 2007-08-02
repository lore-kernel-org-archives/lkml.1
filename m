Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXHBTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXHBTRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXHBTRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:17:24 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:57908
	"EHLO moonbase" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756222AbXHBTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:17:24 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CFS review
Date: Thu, 2 Aug 2007 12:16:56 -0700
User-Agent: KMail/1.9.5
Cc: Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <andi@firstfloor.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <Pine.LNX.4.64.0708011525560.1817@scrub.home> <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021216.57065.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wednesday 01 August 2007 19:17, Linus Torvalds wrote:
>    And the "approximates" thing would be about the fact that we don't
>    actually care about "absolute" microseconds as much as something
> that is in the "roughly a microsecond" area. So if we say "it doesn't
> have to be microseconds, but it should be within a factor of two of a
> ms", we could avoid all the expensive divisions (even if they turn
> into multiplications with reciprocals), and just let people *shift*
> the CPU counter instead.

On that theme, expressing the subsecond part of high precision time in 
decimal instead of left-aligned binary always was an insane idea.  
Applications end up with silly numbers of multiplies and divides 
(likely as not incorrect) whereas they would often just need a simple 
shift as you say, if the tv struct had been defined sanely from the 
start.  As a bonus, whenever precision gets bumped up, the new bits 
appear on the right in formerly zero locations on the right, meaning 
little if any code needs to change.  What we have in the incumbent libc 
timeofday scheme is the moral equivalent of BCD.

Of course libc is unlikely ever to repent, but we can at least put off 
converting into the awkward decimal format until the last possible 
instant.  In other words, I do not see why xtime is expressed as a tv 
instead of simple 32.32 fixed point.  Perhaps somebody can elucidate 
me?

Regards,

Daniel
