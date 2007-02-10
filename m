Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbXBJDVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbXBJDVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXBJDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:21:43 -0500
Received: from emailgw01.pnl.gov ([192.101.109.33]:3686 "EHLO
	emailgw01.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXBJDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:21:42 -0500
X-IronPort-AV: i="4.13,308,1167638400"; 
   d="scan'208"; a="19955766:sNHT27664987"
Subject: Re: NAK new drivers without proper power management?
From: Kevin Fox <Kevin.Fox@pnl.gov>
To: Lee Revell <rlrevell@joe-job.com>
Cc: nigel@nigel.suspend2.net, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <75b66ecd0702091822n19cf88b8k63bbd705cf5367ae@mail.gmail.com>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca>
	 <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com>
	 <1171073398.3863.9.camel@nigel.suspend2.net>
	 <75b66ecd0702091822n19cf88b8k63bbd705cf5367ae@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 19:21:27 -0800
Message-Id: <1171077687.3078.202.camel@zathras.emsl.pnl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1.1 (2.8.1.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 18:22 -0800, Lee Revell wrote:
> On 2/9/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > On Fri, 2007-02-09 at 20:59 -0500, Lee Revell wrote:
> > > On 2/9/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > > > I would disagree that it's a peripheral issue, it's pretty core
> these
> > > > days, at least for any hardware that you can stuff in a laptop
> (though a
> > > > fair number of desktops get suspended and resumed these days
> too).
> > >
> > > Servers are still the most important Linux market, and don't care
> > > about suspend/resume.  I would consider implementing
> suspend./resume
> > > for a driver that will only be used in server or HPC class
> hardware a
> > > waste of valuable development resources.
> >
> > Not necessarily. Imagine suspending to disk in order to replace a
> faulty
> > card. That could be way faster and less disruptive than shutting
> down
> > normally and loosing caches and so on.
> >
> 
> Hmm.  If uptime is critical I would make sure to have redundant
> systems anyway and I would just reboot the thing.  I would not expect
> the suspend/resume paths on server class hardware like 10gig ethernet,
> Infiniband adapters, or high end SCSI to be particularly well tested.

Speaking from the HPC standpoint, we are gaining more and more nodes in
clusters as time goes on, so the potential for single failures affecting
performance is growing. A lot of the server class nodes have redundancy
such that the node slows down but not die on failure. Unfortunately,
slowdown in a single node in a tightly coupled job can greatly affect
performance. A good example would be ECC memory. If a chip is going bad,
the machine can detect it but it will run slower until the memory is
replaced. This one node can affect thousands of other nodes in the same
job. Having a mechanism to migrate the operating system that is running
on this failing node to another node would be quite beneficial to
performance. If all drivers properly supported suspend/resume, it could
possibly be extended to support migration to another node as well. At
least for the HPC world, we'd like to see, and encourage, the hardware
you describe getting full support for suspend/resume.

Kevin

> > Irrespective of the above, servers tend not to have too much in the
> way
> > of hardware unique to them anyway, and even if you don't find it
> useful,
> > that's not to say others won't want it.
> 
> Yes but for such hardware, suspend/resume is likely to be a lot of
> work to implement, and I'd rather the developers devote those
> resources to making the driver as stable and performant as possible.
> 
> I agree 100% that drivers for desktop and laptop hardware should be
> rejected if missing suspend/resume.
> 
> Lee
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
