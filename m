Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXBIRPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXBIRPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992452AbXBIRPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:15:52 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47831 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992449AbXBIRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:15:51 -0500
Message-Id: <1171041349.4099.1173808365@webmail.messagingengine.com>
X-Sasl-Enc: dB0TH3BPUVuRw4D5HHw1GCcP5AyocE53Yw7plOHnaH2H 1171041349
From: "Kai" <epimetreus@fastmail.fm>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
   <20070205203750.7be7f772.akpm@linux-foundation.org>
   <17864.4339.925700.626157@notabene.brown>
   <17865.3776.511594.763544@notabene.brown>
   <1170865619.16808.1173403963@webmail.messagingengine.com>
   <17866.19962.601479.638730@notabene.brown>
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at mm/filemap.c:537!
In-Reply-To: <17866.19962.601479.638730@notabene.brown>
Date: Fri, 09 Feb 2007 09:15:49 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Feb 2007 09:08:58 +1100, "Neil Brown" <neilb@suse.de> said:
> On Wednesday February 7, epimetreus@fastmail.fm wrote:
> > 
> > On Wed, 7 Feb 2007 10:26:56 +1100, "Neil Brown" <neilb@suse.de> said:
> > > On Tuesday February 6, neilb@suse.de wrote:
> > > > 
> > > > This patch should fix the worst of the offences, but I'd like to
> > > > experiment and think a bit more before I submit it to stable.
> > > > And probably test it too - as yet I have only compile and brain
> > > > tested.
> > > 
> > > Ok, I've experimented and tested and now I know what was causing the
> > > double-unlock.
> > > 
> > > The following patch is suitable for 2.6.20.1 and mainline.  There is
> > > room for a bit more improvement, but only for performance, not
> > > correctness.  I'll look into that later.
> > > 
> > > Thanks,
> > > NeilBrown
> > 
> > I figure I should test this on my hardware, but since the RAID array
> > resynched itself when I rebooted back into an earlier kernel version,
> > I'm guessing it means this bug introduced some corruption into the
> > array, when it occurred, so I'd like some pointers on how I can test it
> > out without compromising my data.
> 
> This bug should not introduce any data corruption.
> It causes some read requests to get a failure from the device, which
> will cause raid5 to remove the device from the array (Though the data
> will still be intact).
> On restart a resync will put everything back as it was.
> 
> It is quite possible (this happened to me in my testing) for several
> devices to get these errors and for several or even all of these
> device to get failed.  However even in this case the data is still
> intact and "mdadm --assemble --force ..." will put everything back
> together.
> 
> So there should be no risk of data corruption.
> 
> NeilBrown

I've been running it for the last few hours, and no error output, yet; I
even did some fairly heavy I/O stuff to try and mess with it, but it
hasn't budged. I'm ready to say, works for me.

-Kai
