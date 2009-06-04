Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZFDOBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZFDOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZFDOA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:00:56 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35074 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZFDOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:00:55 -0400
Date: Thu, 4 Jun 2009 09:46:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       slapin@ossfans.org, maxim.osipov@siemens.com,
       dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Subject: Re: [PATCH 03/10] net: add IEEE 802.15.4 socket family
	implementation
Message-ID: <20090604134455.GB2839@tuxdriver.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com> <20090603173214.6d3997f7.akpm@linux-foundation.org> <20090604111634.GA28064@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604111634.GA28064@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 03:16:34PM +0400, Dmitry Eremin-Solenikov wrote:
> On Wed, Jun 03, 2009 at 05:32:14PM -0700, Andrew Morton wrote:
> > On Mon,  1 Jun 2009 18:54:44 +0400
> > Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> > > +	switch (addr->addr_type) {
> > > +	case IEEE802154_ADDR_LONG:
> > > +		rtnl_lock();
> > > +		dev = dev_getbyhwaddr(net, ARPHRD_IEEE802154, addr->hwaddr);
> > > +		if (dev)
> > > +			dev_hold(dev);
> > > +		rtnl_unlock();
> > > +		break;
> > > +	case IEEE802154_ADDR_SHORT:
> > > +		if (addr->pan_id != 0xffff && addr->short_addr != IEEE802154_ADDR_UNDEF && addr->short_addr != 0xffff) {
> > > +			struct net_device *tmp;
> > > +
> > > +			rtnl_lock();
> > > +
> > > +			for_each_netdev(net, tmp) {
> > > +				if (tmp->type == ARPHRD_IEEE802154) {
> > > +					if (IEEE802154_MLME_OPS(tmp)->get_pan_id(tmp) == addr->pan_id
> > > +					  && IEEE802154_MLME_OPS(tmp)->get_short_addr(tmp) == addr->short_addr) {
> > 
> > You must use very wide xterms :(
> 
> ~120 chars in width :)  We prefer to have a single code line split between
> several screen lines, rather than split it manually in some weird places
> just to justify width of 80 chars.

Hopefully you realize that many find this difficult to read -- I just
can't spread my eyes far enough to comprehend the lines.

80 chars is not a hard limit, but it is a good goal.  120 is too wide.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
