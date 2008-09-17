Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYIQREf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYIQREf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYIQRE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:04:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53872 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYIQREZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:04:25 -0400
Date: Wed, 17 Sep 2008 20:04:22 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release	from	2.6.22
 -&gt; 2.6.28
In-Reply-To: <1221659858.8818.13.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.64.0809171953350.26270@wrl-59.cs.helsinki.fi>
References: <1221306287.5213.111.camel@marge.simson.net> 
 <48CD1D25.9080301@linux-foundation.org>  <1221421907.4597.24.camel@marge.simson.net>
  <1221475440.4784.39.camel@marge.simson.net>  <1221568105.5020.17.camel@marge.simson.net>
  <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi> 
 <1221626391.5043.13.camel@marge.simson.net>  <1221627676.5125.3.camel@marge.simson.net>
 <20080917104044.GC18764@elte.hu>  <1221651701.5102.17.camel@marge.simson.net>
 <20080917124943.GA7738@elte.hu>  <1221657111.5511.14.camel@marge.simson.net>
  <Pine.LNX.4.64.0809171629550.1034@wrl-59.cs.helsinki.fi>
 <1221659858.8818.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-337667718-1221671062=:26270"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-337667718-1221671062=:26270
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 17 Sep 2008, Mike Galbraith wrote:

> On Wed, 2008-09-17 at 16:36 +0300, Ilpo Järvinen wrote:
> > On Wed, 17 Sep 2008, Mike Galbraith wrote:
> > 
> > > On Wed, 2008-09-17 at 14:49 +0200, Ingo Molnar wrote:
> > > 
> > > > git log --pretty=format:"%h: %s" 2069f45..847106f | grep -viE \
> > > > 'block|alsa|pcmcia|sound|Merge|iosched|blk|DAC960|scsi|s390|paride|pktcdvd|filter|cdrom|drm'
> > > > 
> > > > gives us:
> > > > 
> > > >  7daf705: Start using the new '%pS' infrastructure to print symbols
> > > >  6f0f0fd: security: remove register_security hook
> > > >  93cbace: security: remove dummy module fix
> > > >  5915eb5: security: remove dummy module
> > > >  b478a9f: security: remove unused sb_get_mnt_opts hook
> > > >  32502b8: splice: fix generic_file_splice_read() race with page invalidation
> > > >  8b3d356: ramfs: enable splice write
> > > >  a144ff0: xen: Avoid allocations causing swap activity on the resume path
> > > > 
> > > > which really only leaves that security commit your bisection fingered. 
> > > > Which _slightly_ raises its likelyhood of being implicated. Structure 
> > > > size changes can move two formerly far-apart netperf-relevant symbols on 
> > > > the same cacheline, which can start cache ping-pong-ing badly.
> > > 
> > > I sure hope it's something like ping-pong, it's driving me NUTS.
> > 
> > How about dividing the problem to smaller blocks then by restoring 
> > parts of the change...
> 
> Well, what I've done is check out the "bad" tree, reverted every darn
> commit between there and the "good" tree, and then reverted the reverts
> so I have a nice merge-free line and don't have to remember to think
> backward.  (probably sounds silly to git-foo masters)  I'll try
> bisecting that in the a.m. and see what happens.

This was my initial idea (which was mainly an error from my part as I 
misread some shaids and midunderstood that the first regressing would be 
the merge instead of the actual change), but in here I meant taking parts 
of the 6f0f0fd on top of 6f0f0fd^. The most easiest way to do that 
actually might be to do in fact the opposite, ie., but some of the 
datastructure/layout changes back on top of 6f0f0fd and see if the 
performance get restored (besides testing the Eric's patch).

-- 
 i.
---696208474-337667718-1221671062=:26270--
