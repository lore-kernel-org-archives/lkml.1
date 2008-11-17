Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYKQQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYKQQqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYKQQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:46:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:57551 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbYKQQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:46:34 -0500
Subject: Re: [patch 2.6.28-rc5] regulator: enable/disable refcounting
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: dbrownell@users.sourceforge.net
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200811170821.47582.david-b@pacbell.net>
References: <200811161144.46582.david-b@pacbell.net>
	 <20081117151636.GG1559@sirena.org.uk>
	 <200811170821.47582.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 16:46:30 +0000
Message-Id: <1226940390.585.4.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 08:21 -0800, David Brownell wrote:
> On Monday 17 November 2008, Mark Brown wrote:
> > On Sun, Nov 16, 2008 at 11:44:46AM -0800, David Brownell wrote:
> > 
> > > +	mutex_lock(&rdev->mutex);
> > > +	if (regulator->enabled == 1) {
> > > +		ret = _regulator_disable(rdev);
> > > +		if (ret == 0)
> > > +			regulator->uA_load = 0;
> > 
> > Why clear the load here?  I'd expect to be able to enable and disable
> > the regulator while preserving the configuration.
> 
> That clear was in the original code.  Didn't make much sense
> to me either, but I was just caring it forward...
> 

Hmm, this looks like a bug - I'll fix in a subsequent patch.

Will have time to look over the rest later tonight.

Thanks

Liam 

