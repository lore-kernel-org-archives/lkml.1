Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXC1Rf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXC1Rf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965054AbXC1Rf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:35:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:30729 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbXC1Rf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OWhj8ZE+ZC4kWmd3GduSNPuVE8Q49Sl14bQnS1Px5W1Liu0yTVjSthiGd56qndxaOjJ52t6KYJiUXvslSTB3rGstLayaRmIqHgA9yBVwt9gWR+pW9TcvG8N5vMD2zRQsgtsROQugLJOyIDI2yTWmpFUCzq1QK2WAu9aTA61M4Vg=
Message-ID: <d120d5000703281035p68180e8cg3c977a2d5ede8e09@mail.gmail.com>
Date: Wed, 28 Mar 2007 13:35:25 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: appletouch quirk doesn't run at resume
Cc: "Thomas Meyer" <thomas@m3y3r.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Peter Osterlund" <petero2@telia.com>
In-Reply-To: <Pine.LNX.4.64.0703281903470.29565@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318004240.GO752@stusta.de>
	 <Pine.LNX.4.64.0703181934530.4195@jikos.suse.cz>
	 <45FD8CA3.10405@m3y3r.de>
	 <Pine.LNX.4.64.0703182020070.4195@jikos.suse.cz>
	 <4609866C.4060602@m3y3r.de>
	 <Pine.LNX.4.64.0703281414410.29565@twin.jikos.cz>
	 <d120d5000703280624q62c26ffbs80e31d557bf3c72b@mail.gmail.com>
	 <460A9D28.5050703@m3y3r.de>
	 <Pine.LNX.4.64.0703281903470.29565@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 28 Mar 2007, Thomas Meyer wrote:
>
> > > I am not sure if this would help... According to the excerpt from X
> > > log synaptics driver attempted to scan evdev devices and locate the
> > > touchpad. However if this scan happen before udev had a chance to
> > > process the event and create new /dev/input/eventX device node it will
> > > fail.
> > Okay. This strengthens above statement. And udev is too slow to create
> > the devices, while the driver already scanned the directory.
> > > I wonder if we should adjust the X driver to spin for a couple of
> > > seconds in EventAutoDevProbe if the touchpad was already seen once...
> > > Peter?
>
> Yes, it looks like this is the root cause.
>
> However I must admit that I don't like this behavior too much. We
> shouldn't rely on drivers individual userland to wait for a reasonable
> time before the udev settles down. This is not a nice API to provide. Will
> try to think of some solution which would have reasonable
> nastiness/functionality ratio.
>

The proper fix would be teach X to recognize hotplug events. I've
heard  they are working on it.

-- 
Dmitry
