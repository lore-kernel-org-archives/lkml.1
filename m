Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXIUKrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXIUKrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXIUKri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:47:38 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:1612 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbXIUKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:47:38 -0400
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
From: richard kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070921033336.c327ffd9.akpm@linux-foundation.org>
References: <46B10BB7.60900@redhat.com>
	 <20070803113407.0b04d44e.akpm@linux-foundation.org>
	 <20070804084426.GA20464@kobayashi-maru.wspse.de>
	 <20070809095943.GA7763@kobayashi-maru.wspse.de>
	 <20070809095534.25ae1c42.akpm@linux-foundation.org>
	 <46F2E103.8000907@redhat.com>
	 <20070920142927.d87ab5af.akpm@linux-foundation.org>
	 <46F2EE76.4000203@redhat.com>
	 <20070920153654.b9e90616.akpm@linux-foundation.org>
	 <1190370341.3121.35.camel@castor.rsk.org>
	 <20070921033336.c327ffd9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 11:47:33 +0100
Message-Id: <1190371653.3121.42.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 03:33 -0700, Andrew Morton wrote:
> On Fri, 21 Sep 2007 11:25:41 +0100 richard kennedy <richard@rsk.demon.co.uk> wrote:
> 
> > > That's all a bit crappy if the wrong races happen and some other task is
> > > somehow exceeding the dirty limits each time this task polls them.  Seems
> > > unlikely that such a condition would persist forever.
> > > 
> > > So the question is, why do we have large amounts of dirty pages for one
> > > disk which appear to be sitting there not getting written?
> > 
> > The lockup I'm seeing intermittently occurs when I have 2+ tasks copying
> > large files (1Gb+) on sda & a small read-mainly mysql db app running on
> > sdb. The lockup seems to happen just after the copies finish -- there
> > are lots of dirty pages but nothing left to write them until kupdate
> > gets round to it. 
> 
> Then what happens?  The system recovers?
Nothing -- it stays stuck forever.
I don't think kupdate is getting started, I added some debug in there
but haven't found out anything useful yet. But I am trying to build a
better test case, the one I've got at the moment can take hours to
trigger this problem. 

