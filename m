Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYKLWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYKLWYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKLWYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:24:01 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:55255 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYKLWYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:24:00 -0500
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
In-Reply-To: <20081112112525.GA8767@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net>
	 <200811100743.34741.david-b@pacbell.net>
	 <20081110165625.GE12804@sirena.org.uk>
	 <200811102056.20008.david-b@pacbell.net>
	 <20081112112525.GA8767@sirena.org.uk>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 22:23:55 +0000
Message-Id: <1226528635.6727.256.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:25 +0000, Mark Brown wrote:
> On Mon, Nov 10, 2008 at 08:56:19PM -0800, David Brownell wrote:
> > On Monday 10 November 2008, Mark Brown wrote:
> 
> > > > imply REGULATOR_MODE_OFF ... another CPU may need to keep
> > > > it in some other state.
> 
> > > regulator_disable() needn't imply that the regulator will actually be
> > > off -
> 
> > Would you say that also for regulator_ops.disable() though?
> 
> If we ignore regulator_force_disable() (which isn't used yet) for the
> moment I'd actually say that in your case with non-software enables it's
> reasonable for it to still be powered by some other part of the system.
> Mainly because it's proably easier to just ignore the other enables than
> it is to explain to the rest of the system that there are others it
> can't know about.
> 
> > Less surprising/confusing would be if regulator_{en,dis}able() did
> > its own refcounting and called down to regulator_dev when changing
> > a per-client refcount to/from zero.  (Easy patch, for later.)
> 
> Yeah, either way is fine for me - don't know if Liam has a strong
> opinion.  The main benefit of not doing it is that encourages people to
> avoid consumers sharing the clients which causes problems when clients
> share the regulator.
> 

Fwiw, the main design intention here was to have a 1:1 mapping between a
consumer device and a struct regulator so that we could easily store per
consumer power data (for mode switching, easier debug, sysfs) and avoid
any issues between sharing the clients. I'd be happy for this change as
long as we can keep the per consumer data.

Thanks

Liam

