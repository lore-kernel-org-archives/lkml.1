Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZKQLwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZKQLwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZKQLwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:52:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42520 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZKQLwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:52:37 -0500
Date: Tue, 17 Nov 2009 12:52:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Magnus Damm <damm@opensource.se>, alsa-devel@alsa-project.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091117115236.GB1376@ucw.cz>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109105858.GB1245@sirena.org.uk> <20091109133136.GC1245@sirena.org.uk> <20091116153000.GB29479@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116153000.GB29479@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-16 15:30:00, Mark Brown wrote:
> On Mon, Nov 09, 2009 at 01:31:36PM +0000, Mark Brown wrote:
> > On Mon, Nov 09, 2009 at 10:58:58AM +0000, Mark Brown wrote:
> > > On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:
> 
> Any chance someone from the PM side could comment on the issue below?
> 
> > > > +static int fsi_runtime_nop(struct device *dev)
> > > > +{
> > > > +	/* Runtime PM callback shared between ->runtime_suspend()
> > > > +	 * and ->runtime_resume(). Simply returns success.
> > > > +	 *
> > > > +	 * This driver re-initializes all registers after
> > > > +	 * pm_runtime_get_sync() anyway so there is no need
> > > > +	 * to save and restore registers here.
> > > > +	 */
> > > > +	return 0;
> > > > +}
> > > 
> > > This sets off alarm bells but it's perfectly reasonable, especially with
> > > platforms able to put things into a low power state with no explicit
> > > driver code now they can do power domain style things like SH.  I've
> > > CCed in the PM folks since this seems like a perfectly reasonable use
> > > case which ought to be handled more nicely.

I believe that having few nop functions around the tree should not be
huge problem. If it is, you can introduce one shared top function into
the core...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
