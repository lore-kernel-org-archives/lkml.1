Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYCKKUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYCKKUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYCKKUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:20:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51588 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752916AbYCKKUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:20:43 -0400
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <200803101739.08628.david-b@pacbell.net>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
	 <200803071943.14805.david-b@pacbell.net>
	 <1205061053.13653.114.camel@localhost.localdomain>
	 <200803101739.08628.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 10:20:41 +0000
Message-Id: <1205230841.13653.204.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 16:39 -0800, David Brownell wrote:
> On Sunday 09 March 2008, Liam Girdwood wrote:
> > 
> > > > +struct regulator *__must_check regulator_get(struct device *dev,
> > > > +                                            const char *id);
> > > 
> > > The semantics of "id" and "dev" are unspecified in this patch,
> > > so this isn't a good definition of the consumer interface!
> > > 
> > 
> > 'id' is really the regulator name and will be renamed in the next patch.
> 
> Still not helping.  How would a driver know what names to use?

Platform data i.e. "WM8350-DCDC1". The links I gave in a previous mail
have examples for this wrt LED. Backlight drivers.

> Are those names globally scoped, or local to the device?
> 

They are global.

> Again, "id" and "dev" are unspecified.  I can maybe guess that
> you're trying to make this look like <linux/clk.h> ... except
> the clock API includes kernel doc in that header.
> 
> I *strongly* think new interfaces should not be provided without
> documentation... but that's what this patch does.
> 

Fair point, I'll add docs for v4.

> 
> > > Plus, that works more like a "lookup" than a "get" ... the
> > > usual convention is that "get" and "put" update refcounts.
> > > But I think I see an assumption here that a regulator may
> > > have only one user...
> > 
> > A regulator only has one user as it's used to store some device specific
> > power data. However, a regulator_dev has many users. I'll add a refcount
> > on get/put.
> 
> I'm still not following.  If there's only one user, why would
> you need refcounting?  If your model here is the clock API,
> then you should support multiple users ... and then refcounting
> is very appropriate.
> 

Maybe the naming is confusing here. We should probably rename regulator
to regulator_client or similar.

Liam


