Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbXFSDwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbXFSDwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760545AbXFSDwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:52:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52221 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763435AbXFSDwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:52:38 -0400
To: Tim Bird <tim.bird@am.sony.com>
cc: holzheu@linux.vnet.ibm.com, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Reply-To: Gerrit Huizenga <gh@us.ibm.com>
From: Gerrit Huizenga <gh@us.ibm.com>
Subject: Re: [RFC/PATCH] Documentation of kernel messages 
In-reply-to: Your message of Mon, 18 Jun 2007 17:13:19 PDT.
             <46771F9F.40608@am.sony.com> 
Date: Mon, 18 Jun 2007 20:52:30 -0700
Message-Id: <E1I0Ulb-0000UX-4S@w-gerrit.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 Jun 2007 17:13:19 PDT, Tim Bird wrote:
> Gerrit Huizenga wrote:
> > Further, yet another kernel config option could allow distros to output
> > the calculated MD5 sum to be printed, much like we do with timestamps
> > today.
> 
> > Comments?
> 
> Would the compiled-in text then also become replaceable?
> Or is the MD5 sum output expected to be in addition to
> the regular English message?
 
 The MD5 sum would be calculated at print time, no proposal in
 here to replace the in-kernel text.  And, I'm not sure that replacing
 it with an MD5 sum would every be significantly shorter, ergo
 I don't think this helps your problem.

 The methods of post-processing to "shrink" the kernel text here
 seem too ugly to ponder.  And I just pondered a few that made my
 head hurt (sort the MD5 sums, re-insert the number of the MD5 sum
 as an integer instead of the original text, and, beyond being gross,
 what do you do with the formatting info about the args?).

> If message replacement at compile-time is supported, this
> could allow for creating "short" versions of the messages,
> which could have a beneficial impact on kernel size.
> 
> Right now, it is possible to completely disable printks
> and re-claim about 100K of memory.  However, in some
> embedded configurations, even if you are space-constrained
> it's desirable to retain some of the printks, for in-field
> debugging.  Thus not very many embedded developers
> disable printks completely, even though the option has
> been supported for a while.  (That, and many aren't caught
> up to the kernel version where it was introduced (2.6.10) :-)

 Which ones matter?  Odds are you could use the KERNEL_LOGLEVEL or
 such to mark those, then compile out the rest.

> But compressed messages (shortened text through abbreviations,
> or just outputting the ID alone, etc.) could save SOME
> of the space, in trade for less readability.  Heck, just
> removing all vowels would probably save 10k, and not
> hurt readability that much.
 
 Ick.  Are you serious?  How about running them through a valley
 girl filter and then converting to high school text messaging?

> Finally, for testing, it's handy to also
> have automatic translation generators.
> At a former company I worked for, they had translators
> that would output:
>  * all messages shortened by 20%
>  * all messages lengthened by 20%
>  * every message converted to pig-latin

 Double yucko.

> These were mostly used for testing if the strings broke
> screen real-estate constraints (which don't apply to
> kernel messages).  But the automatic translators
> would sometimes catch messages with weird attributes.
 
  I don't think people are worried about the correctness of
  the messages and message formats - much of that can actually
  be detected by simple tools.  The goal here was to at least
  allow people that support operating systems and for whom
  English (and English collation sequences) is not a primary
  language do some initial system diagosis.

  I think compiling out the messages of something below some LOGLEVEL
  is a lot more practical.

gerrit
