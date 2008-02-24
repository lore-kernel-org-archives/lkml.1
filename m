Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYBXHsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYBXHsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYBXHsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:48:37 -0500
Received: from lazybastard.de ([212.112.238.170]:60234 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYBXHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:48:36 -0500
Date: Sun, 24 Feb 2008 08:47:31 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Newall <davidn@davidnewall.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080224074730.GB31293@lazybastard.org>
References: <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com> <20080222020615.GE27894@ZenIV.linux.org.uk> <m3myptsp8u.fsf@maximus.localdomain> <20080222031315.GF27894@ZenIV.linux.org.uk> <m38x1c4od1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m38x1c4od1.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 February 2008 23:28:58 +0100, Krzysztof Halasa wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > IMO the line length overruns make good warnings.  Not as in "here's a cheap
> > way to get more changesets", but as in "that code might have other problems
> > nearby" kind of heuristics.
> 
> Sure, it does. However the human looking at the code is far better at
> spotting such problems. Machine-generated warnings are great when the
> machine is actually better than human.

I strongly disagree.  Machine-generated warnings are a great way of
quickly locating a large amount of questionable code in an otherwise
overwhelming haystack.  It doesn't even matter much, which warnings you
look for.  Almost all code checkers find the same hotspots.

But there is a catch.  If you have an over-eager warning police that
"fixes all the warnings", the warnings may be gone, but the very real
problems in near vicinity are not.  Not to mention new problems
introduced by those claimed "fixes".

One fun hobby in my last job was to write a new code checker and locate
those problem areas hidden behind warning-free code.  I had to write a
new checker so I would see below the polish of "fixes".  The actual
problems found by the checker were often trivial and near-meaningless.
But those warnings are not the point at all, quite the contrary.  The
only important thing was "that code might have other problems nearby".

Note one scary consequence: code checkers in the wrong hands are
actively harmful.

Jörn

-- 
One of my most productive days was throwing away 1000 lines of code.
-- Ken Thompson.
