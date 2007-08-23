Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXHWHJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXHWHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXHWHJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:09:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbXHWHJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:09:16 -0400
Date: Thu, 23 Aug 2007 00:07:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: 2.6.23-rc3-mm1: fix b43 compilation
Message-Id: <20070823000737.cbf85d70.akpm@linux-foundation.org>
In-Reply-To: <20070823025614.GA4855@tuxdriver.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<200708221833.59375.rjw@sisk.pl>
	<200708222356.44088.mb@bu3sch.de>
	<20070823025614.GA4855@tuxdriver.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 22:56:15 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:

> On Wed, Aug 22, 2007 at 11:56:43PM +0200, Michael Buesch wrote:
> > On Wednesday 22 August 2007 18:33:58 Rafael J. Wysocki wrote:
> > > On Wednesday, 22 August 2007 11:06, Andrew Morton wrote:
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > > > 
> > > > - git-ixgbe.patch got dropped - git-net.patch destroyed it
> > > > 
> > > > - then git-net got dropped as it doesn't work
> > > 
> > > Apparently, the b43 driver is expecting another version of mac80211.
> > > 
> > > This patch fixes the compilation, but I'm not sure what about the
> > > functionality. ;-)
> > 
> > There seems to be a screwup somehow.
> > These mac80211 API functions were recently changed to include
> > the additional parameter. So it seems you carry an old version of mac80211.
> 
> I think what happened is because Andrew dropped Dave M.'s net tree.
> Since mac80211 has been getting merged through Dave M., crucial bits
> are missing which then break the bits from wireless-dev.

argh, I didn't know that.  I wonder why all my compile testing passed.

> Andrew, if you find that you need to drop git-net again then I'll be
> happy to provide you with a wireless-dev patch that does not depend on
> Dave's tree.  The mm-master branch in wireless-dev has dropped those
> patches which have gone to Dave M. in the hopes of avoiding conflicts.
> Dependencies are another matter... :-)

Hopefully git-net is less wrecked than it was yesterday.  If things still
play up I'll have a go at bodging it up a bit, perhaps by disabling
netconsole.  (Although now I think about it, the netconsole bug was mainly
an ill-advised BUG_ON, fixable by using WARN_ON instead).



