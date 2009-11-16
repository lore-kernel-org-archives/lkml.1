Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZKPPaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZKPPaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZKPPaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:30:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33907 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZKPPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:30:01 -0500
Date: Mon, 16 Nov 2009 15:30:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Subject: Null suspend/resume functions
Message-ID: <20091116153000.GB29479@sirena.org.uk>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109105858.GB1245@sirena.org.uk> <20091109133136.GC1245@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109133136.GC1245@sirena.org.uk>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 01:31:36PM +0000, Mark Brown wrote:
> On Mon, Nov 09, 2009 at 10:58:58AM +0000, Mark Brown wrote:
> > On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:

Any chance someone from the PM side could comment on the issue below?

> > > +static int fsi_runtime_nop(struct device *dev)
> > > +{
> > > +	/* Runtime PM callback shared between ->runtime_suspend()
> > > +	 * and ->runtime_resume(). Simply returns success.
> > > +	 *
> > > +	 * This driver re-initializes all registers after
> > > +	 * pm_runtime_get_sync() anyway so there is no need
> > > +	 * to save and restore registers here.
> > > +	 */
> > > +	return 0;
> > > +}
> > 
> > This sets off alarm bells but it's perfectly reasonable, especially with
> > platforms able to put things into a low power state with no explicit
> > driver code now they can do power domain style things like SH.  I've
> > CCed in the PM folks since this seems like a perfectly reasonable use
> > case which ought to be handled more nicely.
