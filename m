Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXDWGxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXDWGxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDWGw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:52:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54272 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXDWGw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:52:58 -0400
Date: Sun, 22 Apr 2007 23:53:09 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070423065309.GA20149@kroah.com>
References: <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com> <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com> <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com> <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com> <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com> <462856B9.9010307@gmail.com> <d120d5000704200935r2fb1e614m6da149eee0aec5b6@mail.gmail.com> <4628EFB2.9070709@gmail.com> <d120d5000704201059o750cc95am349707d353f79f10@mail.gmail.com> <462C54D5.6000101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462C54D5.6000101@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 03:40:21PM +0900, Tejun Heo wrote:
> Hello, Dmitry.
> 
> Dmitry Torokhov wrote:
> > Isn't think a good thing? By decoupling the 2 layers we insulate them
> > from changes in each other. This allows bug subsystems to concentrate
> > on topics that important to them instead of worying about refcounting
> > objects that are not directly interesting for the subsystem in
> > question.
> 
> I think the best thing would be make struct device's lifetime rules
> simple enough such that it doesn't really matter to driver subsystems
> and drivers can just do what they wanna do.

I agree.

> Also, separate struct device from the actual implementation has problem
> in that struct device is widely used to refer to the device by many
> layers drivers register devices to.  Basically, you'll have to implement
> immediate-disconnect between struct device and the actual
> implementation.  So, it just shifts the problem from struct device to
> the place between struct device and actual implementation and I think
> struct device itself is better place to deal with that than somewhere
> inbetween it and driver private data.

I also agree.

> > Now for smaller subsystems it may make sense to embed stuct devices
> > into subsystem objects and manage it all together. In fact input
> > system does this but I think it is much simlpier than SCSI or IDE.
> 
> Well, both SCSI and IDE heavily depend on struct device acting as 'base
> class'.  It's all over the place and almost a basic assumption about the
> driver model.

And that's how it should be.

And your sysfs patches now make it a lot easier than before, and I can't
thank you enough for doing that work.

thanks,

greg k-h
