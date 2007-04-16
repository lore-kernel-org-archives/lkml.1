Return-Path: <linux-kernel-owner+w=401wt.eu-S1030953AbXDPUUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030953AbXDPUUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030954AbXDPUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:20:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:55638 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030953AbXDPUUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kVtrVAUS9oiUm4b9Yd/teiUW5D2yMK3iQdj7WAskNZKwc5cGIqwmbN5LibTGpsycvLvG1GJCleWldFOxe2YsI0N5HCAVCBFzTbvmbT3eGfPPw4QcTWfg/+Aug+UyHDrXwykS4ov+tojp560b8ElhJa6CQofMX36xO/9YH/RL8zk=
Message-ID: <d120d5000704161320x6a9be38dqc71d708e534dd7b4@mail.gmail.com>
Date: Mon, 16 Apr 2007 16:20:18 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Tejun Heo" <htejun@gmail.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070416191120.GA15490@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	 <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
	 <20070416184716.GA6262@kroah.com>
	 <d120d5000704161203j7c476bb8m1c96d09adb819b6f@mail.gmail.com>
	 <20070416191120.GA15490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 16, 2007 at 03:03:16PM -0400, Dmitry Torokhov wrote:
> > On 4/16/07, Greg KH <greg@kroah.com> wrote:
> > >On Mon, Apr 16, 2007 at 02:30:17PM -0400, Dmitry Torokhov wrote:
> > >> On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > >> >Hi,
> > >> >
> > >> >based on the discussion in "How should an exit routine wait for
> > >> >release() callbacks?", I've cooked up some patches that make module
> > >> >unload wait until the last reference for a kobject has been dropped.
> > >> >This should plug the "release function in already deleted module" race;
> > >> >however, if the last kobject_put() from the module containing the
> > >> >release function is not in the module's exit function, there's still a
> > >> >small window (not sure if and how to plug this).
> > >>
> > >> Unfortunately all this "wait for refcount in module's exit" schemas
> > >> lead to the following deadlock:
> > >>
> > >>        rmmod my_module < /path/to/some/file/incrementing/my/refcount
> > >
> > >No, it should just return "module in use" as the reference count it
> > >grabbed before rmmod is called.
> > >
> >
> > No, because it it were module's refcount we woudl not have problem
> > with ->release() to begin with. It is object's refcount.
>
> Yes, but with these patches, we are incrementing that reference count
> when the kobject is created, which will cause this to fail.
>

Then you will never be able to unload the module, not with the current
module tools.

> > >But either way, that's just foolish to try to prevent that from failing
> > >:)
> >
> > Why? It works now for most of teh subsystems.
>
> That's because it is buggy :)
>

Depends on the subsystem.

-- 
Dmitry
