Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbXHAIQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbXHAIQC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbXHAIPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:15:47 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:34343 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbXHAIPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:15:45 -0400
Date: Wed, 1 Aug 2007 17:15:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801081500.GA8723@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070731230932.a9459617.akpm@linux-foundation.org> <20070801062501.GB7581@linux-sh.org> <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 03:58:48AM -0400, Mike Frysinger wrote:
> On 8/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
> > > - Is anyone testing the kgdb code in here?
> >
> > Testing, yes. Succeeding, no. It's utterly hosed on SH in its present
> > condition at least. Presumably it's been tested on at least one platform
> > with some measure of success, but it's certainly not mine ;-)
> 
> does kgdb actually have a chance to get merged ?  with the history of
> it, i just assumed it was never going in, so we've been using our own
> kgdb patch on Blackfin ... so the version *we have* works great :) but
> if there's a chance of this actually going mainline, we can see about
> testing that version as well ...

The generic code has a better chance of being merged if it actually works
at least and doesn't break every platform out there that has an existing
stub. It offers quite a bit of new functionality and does clean things up
a bit, so it would certainly be nice to get things to use that, rather
than having to duplicate all of this crap in the architectures. If it's
not going to be merged, everyone will of course continue using the
existing in-tree stubs (sh, ppc, etc.).

It's generally advantageous to get these things working on your
architecture _before_ things are merged however, as it's one less thing
to catch up on after the fact. It also helps to figure out if there are
issues with the current implementation by trying it out on your platform
in advance, it's a lot more work to push back against it once it's
already merged.

The fact that no one has bothered to even compile for the platforms the
generic kgdb stuff is ported to does seem to suggest that the kgdb folks
aren't terribly serious about getting it merged, though.
