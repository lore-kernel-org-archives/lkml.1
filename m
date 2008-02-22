Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYBVJDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYBVJDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYBVJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:03:22 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51540 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYBVJDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:03:15 -0500
Date: Fri, 22 Feb 2008 11:02:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Junio C Hamano <junio@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Greg Kroah-Hartman <greg@kroah.com>,
       David Newall <davidn@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Roland Dreier <rdreier@cisco.com>, Faisal Latif <flatif@NetEffect.com>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
Message-ID: <20080222090228.GH28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com> <20080222020615.GE27894@ZenIV.linux.org.uk> <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org> <7vbq69pkqy.fsf@gitster.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7vbq69pkqy.fsf@gitster.siamese.dyndns.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 10:29:09PM -0800, Junio C Hamano wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > So I'd be happier with warnings about deep indentation (but how do you 
> > count it? Will people then try to fake things out by using 4-space indents 
> > and then "deep" indentations will look like just a couple of tabs?) and 
> > against complex expressions (ie "if ((a = xyz()) == NULL) .." should just 
> > be split up into "a = xyz(); if (!a) ..", but there are sometimes reasons 
> > for those things too!
> 
> Deep indentation should be fairly easy, given that you
> already have rules in place that says "Tabs are 8 characters".
> So if you find a line that begins with more than say 4 SP, you
> can flag that as already bogus (i.e. "does not indent with HT"),
> more than 8 SP definitely so.
>...

Checkpatch already has an error "use tabs not spaces".

And people should realize that checkpatch is not a tool for janitors but 
for authors and maintainers to easily spot some of the possible problems 
in a driver and thereby automate some part of patch review.

E.g. in this driver we are talking about checkpatch warns about the
> 2000 lines over 80 characters.

And that's not a surprise and a symptom when code is 6 tabs indented.

If someone said fixing that should not delay the merge of a 16.500 lines
driver I would agree with that since fixing that would require a huge 
amount of work for a not that big gain.

But that a merged driver contains > 250 checkpatch errors is really not 
nice. Most of them are easy to fix stylistic errors that simply make the 
driver easier to read and whose fixing would only take a few hours 
altogether. [1]

And the 13 checkpatch errors about volatile usage are not stuff for 
janitors (unless you count our number one cleanup person Al as janitor) 
but indicate really fishy code.

cu
Adrian

[1] one might argue whether "easier to read" really applies when 
    checkpatch gives errors for e.g. the usage of C99 comments, but
    different from overly long lines that's at least stuff that can
    be fixed very quickly and in a quite automatic way

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

