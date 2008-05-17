Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYEQU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYEQU0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYEQU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:26:37 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:58858 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYEQU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:26:36 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
 <20080517015705.GA20375@mit.edu>
 <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
 <20080517145802.GB6978@mit.edu>
Date: Sat, 17 May 2008 13:26:19 -0700
In-Reply-To: <20080517145802.GB6978@mit.edu> (Theodore Tso's message of "Sat,
 17 May 2008 10:58:04 -0400")
Message-ID: <7vabiobrtg.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 8B3806CA-244F-11DD-B195-80001473D85F-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> Basically, this would be the subsystem maintainer sometimes wearing an
> "end-point-developer" hat, and sometimes wearing a "subsystem
> maintainer" hat.  So rebasing is fine as long as it's clear that it's
> happening on branches which are not meant as a base for
> submaintainers.  
>
> I believe Junio does this himself for his own topic branches while
> developing git, yes?

Yes, I used to and I still do sometimes.  Anything not merged to 'next'
yet is a fair game for rebasing.  'pu' is strictly a patch queue in that
sense.

When I am shuffling the topics that are not merged to 'next', I am not
just wearing an end-point-developer hat, but pretending to be the original
contributor (iow "how the patch could have been done better than the one
that I received via e-mail") more often than not these days; I am writing
less and less new code myself.

I used to religiously rebase topics that were not in 'next' on top of
updated 'master' before I rebuilt 'pu' [*1*].  This was partly because
when the topic eventually becomes 'next' worthy, the commit on 'next' to
merge the topic will not have a parent that is too stale (and graphically
the end result would look easier to view that way) if I did so, and partly
because rebasing is one cheap way to detect and resolve conflicts with
'master' much earlier before the topic becomes ready to be merged to
'next'.

I do not however do that so often anymore.

Whenever I rebuild 'pu' starting from the tip of 'next', merging these
uncooked topics, if they have conflicts with 'master' or 'next', I'd
resolve them right there.  Next day, when I rebuild 'pu' again from
updated 'next', it is very likely that I have to resolve the _same_
conflicts again, but that process is largely automated because git
remembers the conflict resolution I did when I merged that topic to 'pu'
the previous day.  After the topics are polished further and when they are
ready to be merged to 'next', the story is the same.  The same conflicts
need to be resolved but that is largely automated.  That is one of the
reasons I do not rebase topics as often as I used to these days.  IOW, I
rely on and trust "rerere" magic a bit more than I used to.

[Footnote]

*1* My "git day" goes like:

 - advance 'maint' with obviously good patches, merges from completed
   'maintenance' topics, and merges from subsystem trees;

 - merge updated 'maint' to 'master';

 - advance 'master' with obviously good patches, merges from completed
   topics, and merges from subsystem trees;

 - merge updated 'master' to 'next';

 - apply new patches into new topics forked from either 'maint' (if it
   should eventually fix breakage in the maintenance track), 'master', or
   some existing topic (if it has functional dependencies on it);

 - apply update patches to existing topics;

 - possibly rebase topics that have not been in 'next' but are now ready
   for 'next';

 - merge topics that are 'next' worthy to 'next';

 - reset 'pu' to 'next';

 - merge remaining topics to 'pu';
