Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYIXW5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYIXW5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYIXW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:57:44 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:52488
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016AbYIXW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:57:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncBACNi2kh8qNU+/2dsb2JhbAAIvVSBZQ
X-IronPort-AV: E=Sophos;i="4.33,303,1220198400"; 
   d="scan'208";a="392163350"
Subject: Re: UIO device name
From: Ben Nizette <bn@niasdigital.com>
To: joakim.tjernlund@transmode.se
Cc: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
	 <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 25 Sep 2008 08:57:37 +1000
Message-Id: <1222297057.4037.12.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-24 at 14:38 +0200, Joakim Tjernlund wrote:
> On Wed, 2008-09-24 at 20:47 +0900, Paul Mundt wrote:
> > > 
> > Nonsense, there is nothing wrong with UIO's interface as it is today.
> > It is no different from sound cards, cdroms, and so on. If you want the
> 
> It is different, cdroms and audio are named differently. If they were
> using UIO they would all be named /dev/uio%d.
> 
> Consider uio_cif and uio_smx, is it impossible to image that such
> devices could use another name such as crypto_smx%d instead?
> 

My system does use uio_smx and uio_pdrv, they both appear as /dev/uioX.
This to me is just like having /dev/hda, /dev/hdb rather
than /dev/myrootpartition, /dev/somebackupspace or whatever.  In this
case you do have a /dev/cdrom symlink but it's just that, a symlink set
up by scripts.  The kernel doesn't (and shouldn't) make that naming
decision for you.

My software just walks /sys/class/uio/uioX/name, finds the one which
matches then opens the corresponding device.  No scripts needed, no
in-kernel hackery or policy making, just the interface used as the maker
intended.  What's your problem with this approach?

The only software you need is the software you have anyway, the stuff
which opens the device also discovers which device to open.

	--Ben.


