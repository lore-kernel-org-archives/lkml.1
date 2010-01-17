Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676Ab0AQN1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0AQN1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930Ab0AQN1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:27:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0AQN1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:27:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Sun, 17 Jan 2010 14:27:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001170138.37283.rjw@sisk.pl> <201001170224.36267.oliver@neukum.org>
In-Reply-To: <201001170224.36267.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001171427.27954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 January 2010, Oliver Neukum wrote:
> Am Sonntag, 17. Januar 2010 01:38:37 schrieb Rafael J. Wysocki:
> > > Now having said that, we've been considering a change that will turn all
> > > GFP_KERNEL allocations into GFP_NOIO during suspend/resume, so perhaps I'll
> > > prepare a patch to do that and let's see what people think.
> > 
> > If I didn't confuse anything (which is likely, because it's a bit late here
> > now), the patch below should do the trick.  I have only checked that it doesn't
> > break compilation, so please take it with a grain of salt.
> > 
> > Comments welcome.
> 
> I think this is a bad idea as it makes the mm subsystem behave differently
> in the runtime and in the whole system cases.

s/runtime/suspend/ ?

Yes it will, but why exactly shouldn't it?  System suspend/resume _is_ a
special situation anyway.

> What's so hard about telling people that they need to use GFP_NOIO in
> suspend() and resume()?

Memory allocations are made for other purposes during suspend/resume too.  For
example, new kernel threads may be created (for async suspend/resume among
other things).

Besides, the fact that you tell people to do something doesn't necessary imply
that they will listen. :-)

I have discussed that with Ben for a couple of times and we have generally
agreed that memory allocation problems during suspend/resume are not avoidable
in general unless we disable __GFP_FS and __GFP_IO at the high level.

Rafael
