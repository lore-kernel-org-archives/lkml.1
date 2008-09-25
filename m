Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYIYLyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYIYLyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYIYLx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:53:58 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:13126 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753162AbYIYLx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:53:57 -0400
Date: Thu, 25 Sep 2008 20:53:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Ben Nizette <bn@niasdigital.com>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO device name
Message-ID: <20080925115337.GA9334@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Ben Nizette <bn@niasdigital.com>,
	"Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de,
	Linux-Kernel <linux-kernel@vger.kernel.org>
References: <20080924093551.GB7591@linux-sh.org> <1222250279.12624.195.camel@gentoo-jocke.transmode.se> <20080924102230.GB2973@local> <1222255981.12624.215.camel@gentoo-jocke.transmode.se> <20080924114743.GA9694@linux-sh.org> <1222259894.12624.247.camel@gentoo-jocke.transmode.se> <1222297057.4037.12.camel@moss.renham> <1222337151.12624.293.camel@gentoo-jocke.transmode.se> <1222339729.3938.15.camel@moss.renham> <1222342868.12624.304.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222342868.12624.304.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 01:41:08PM +0200, Joakim Tjernlund wrote:
> On Thu, 2008-09-25 at 20:48 +1000, Ben Nizette wrote:
> > UIO is an interface type, not a bus type.  UIO isn't a subsystem as
> > such, it's a user interface.  If the interface is consistent (even if
> > the backing device is different) I don't see the problem with consistent
> > naming.
> 
> Do you see a problem with letting the protocol driver choose another
> one? Why not offer the user the chance to let the name mean something?
> 
This thread is still going? Amazing. Anyways, your protocol driver
argument doesn't make any sense. Take the case of uio_pdrv or the genirq
variant. This is the name it hands off to the core, while the devices
that register underneath it all have their own names set. Go grep for all
instances of uio_pdrv platform data in the architecture code. I'm getting
the impression you haven't actually even bothered to look at the name
entries.

Breaking the uio%d stuff is unacceptable, and if you need explanations
for why, then you really shouldn't be touching subsystem code in the
first place. Additionally, so far you haven't been able to show a single
example of something you can't already do with the information in
userspace today. If you want more descriptive names, use udev or symlinks
you kick off from the script.
