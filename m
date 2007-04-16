Return-Path: <linux-kernel-owner+w=401wt.eu-S1030936AbXDPUKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030936AbXDPUKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030937AbXDPUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:10:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030936AbXDPUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:10:19 -0400
Date: Mon, 16 Apr 2007 12:11:20 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Message-ID: <20070416191120.GA15490@kroah.com>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com> <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com> <20070416184716.GA6262@kroah.com> <d120d5000704161203j7c476bb8m1c96d09adb819b6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000704161203j7c476bb8m1c96d09adb819b6f@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:03:16PM -0400, Dmitry Torokhov wrote:
> On 4/16/07, Greg KH <greg@kroah.com> wrote:
> >On Mon, Apr 16, 2007 at 02:30:17PM -0400, Dmitry Torokhov wrote:
> >> On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> >> >Hi,
> >> >
> >> >based on the discussion in "How should an exit routine wait for
> >> >release() callbacks?", I've cooked up some patches that make module
> >> >unload wait until the last reference for a kobject has been dropped.
> >> >This should plug the "release function in already deleted module" race;
> >> >however, if the last kobject_put() from the module containing the
> >> >release function is not in the module's exit function, there's still a
> >> >small window (not sure if and how to plug this).
> >>
> >> Unfortunately all this "wait for refcount in module's exit" schemas
> >> lead to the following deadlock:
> >>
> >>        rmmod my_module < /path/to/some/file/incrementing/my/refcount
> >
> >No, it should just return "module in use" as the reference count it
> >grabbed before rmmod is called.
> >
> 
> No, because it it were module's refcount we woudl not have problem
> with ->release() to begin with. It is object's refcount.

Yes, but with these patches, we are incrementing that reference count
when the kobject is created, which will cause this to fail.

> >But either way, that's just foolish to try to prevent that from failing
> >:)
> 
> Why? It works now for most of teh subsystems.

That's because it is buggy :)

thanks,

greg k-h
