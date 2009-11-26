Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZKZMve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZKZMve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZKZMvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:51:33 -0500
Received: from mail1.radix.net ([207.192.128.31]:43794 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbZKZMvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:51:32 -0500
Subject: Re: linux-next: workqueues tree build failure
From: Andy Walls <awalls@radix.net>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
       ext Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <200911261344.32051.peter.ujfalusi@nokia.com>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
	 <200911261131.15155.peter.ujfalusi@nokia.com>
	 <20091126101859.GA27562@rakim.wolfsonmicro.main>
	 <200911261344.32051.peter.ujfalusi@nokia.com>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 07:49:56 -0500
Message-Id: <1259239796.3062.20.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 13:44 +0200, Peter Ujfalusi wrote:
> On Thursday 26 November 2009 12:18:59 ext Mark Brown wrote:
> > On Thu, Nov 26, 2009 at 11:31:15AM +0200, Peter Ujfalusi wrote:
> > > For a quick fix, I can convert the tlv320dac33 driver to use this, and
> > > revisit later, if it does not fulfill the timing requirements for the HW.
> > 
> > If there are problems then creating a dedicated thread you can wake
> > would probably do the job.
> 
> For now I'm going to change the create_rt_workqueue to 
> create_singlethread_workqueue, that is available at the wq.git of kernel.org.
> 
> If it is not sufficient, than I might use dedicated thread, which I woke up, but 
> I would like to keep that as a backup plan, since it needs more work ;)

Peter,

I would suspect using a single-threaded workqueue is better than a
wake_up() of another thread.  IIRC, after queuing work, the workqueue's
single thread may run almost immediately on the same processor.  With
waking up sleeping threads, I've run into scheduler delays around 10 ms
on a dual core x86_64 desktop system.

Regards,
Andy

> I'll send the patch in a few minutes.


