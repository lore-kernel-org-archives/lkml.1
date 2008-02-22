Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbYBVDOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbYBVDOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbYBVDOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:14:09 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758275AbYBVDOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:14:08 -0500
Date: Thu, 21 Feb 2008 19:13:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Newall <davidn@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <20080222020615.GE27894@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi>
 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com> <20080222020615.GE27894@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Feb 2008, Al Viro wrote:
>
> ... if your style is lousy.  I agree that situation with printks is
> not normal in that respect and I certainly have no love for the
> checkpatch nonsense, but pressure to keep the fucking nesting depth
> low is a Good Thing(tm).

I do agree, but that has little to do with line length *directly*.

IOW, I'd personally be happier with a checkpatch that calculated 
"complexity" and indentation over line length.

There is definitely a correlation there: there is no question that complex 
lines with deep indentation tend to be long. So yes, "long lines are 
correlated with bad code" is certainly true to some degree.

But sometimes lines are long just because it's a function call with 
multiple parameters, and it's just three levels indented, and it had a 
string there too. It may be long, but it's not complex, and keeping it on 
one line actually makes it much easier to visually parse (and grep for, 
for that matter).

So I'd be happier with warnings about deep indentation (but how do you 
count it? Will people then try to fake things out by using 4-space indents 
and then "deep" indentations will look like just a couple of tabs?) and 
against complex expressions (ie "if ((a = xyz()) == NULL) .." should just 
be split up into "a = xyz(); if (!a) ..", but there are sometimes reasons 
for those things too!

		Linus
