Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0BCWeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:34:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab0BCWeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:34:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Date: Wed, 3 Feb 2010 23:34:37 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201002030244.23989.rjw@sisk.pl> <20100202174853.67eeccdd.akpm@linux-foundation.org>
In-Reply-To: <20100202174853.67eeccdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002032334.37198.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, Andrew Morton wrote:
> On Wed, 3 Feb 2010 02:44:23 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > +static inline gfp_t clear_gfp_allowed_mask(gfp_t mask)
> > +{
> > +	gfp_t ret = gfp_allowed_mask;
> > +	gfp_allowed_mask &= ~mask;
> > +	return ret;
> > +}
> 
> Fair enuf.
> 
> Of course, this is all horridly racy/buggy without locking.  Would I be
> correct in hoping that all the callers happen when the system is in
> everyone-is-frozen mode?

As far as I can tell, gfp_allowed_mask is only touched during init apart from
this.

> Perhaps we should add some documentation (or even an assertion) to
> prevent someone from using these interfaces from within normal code.

I thought about that, but didn't invent anything smart enough.

Well, maybe except for a comment like "this must be called with pm_mutex held",
because that's the only case when it would be really safe.

Rafael
