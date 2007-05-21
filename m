Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXEUPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXEUPeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXEUPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:34:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:62455 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbXEUPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W1VQQgWefTYzz/UOPovMCOPu8T0Fgfh2LYSYSBI3sKJKMFyCd7lPxlNp0k81TxWKChlRxcKmxiAPYVLKUQcalAeT9ObihUO8Rt+H/r3usN6fnR3e1G8BdYYzZZb3naINzxv9CzgxrIxNgHhEWPsje1OXpZRDxYiqRmJzgz+ubgc=
Message-ID: <9e4733910705210834s4b41cf31ka3f56d3bc36b5585@mail.gmail.com>
Date: Mon, 21 May 2007 11:34:03 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <4650F5F2.4000305@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <pan.2007.05.20.17.41.22@gmail.com>
	 <200705201610.32170.jbarnes@virtuousgeek.org>
	 <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
	 <4650F5F2.4000305@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jon Smirl wrote:
> > This design still requires a global server app since the heads share a
> > single device.
> > I am always concerned that the root priv code in the X server is a
> > potential security hole. I would like to move away from a model where
> > there is a global controlling app. I don't think we need a global
> > controlling app at all.
>
>
> If you have multiple "controlling" apps competing for a single device,
> that either implies complexity in each app for sharing control, or
> moving even more code into the kernel for 2D and 3D.
>
> I don't think the kernel community is yet interested in moving
> everything of consequence into the kernel.

Before dismissing this you might want to spend some time designing it.

When I said head I should have been more specific and said CRTC. CRTCs
are pretty much independent from each other and can be assigned one
per device. I believe this has already been done in the Matrox fbdev
driver. I have also prototyped this on the Radeon hardware and it
works. It is how fbdev was designed to work. As for 3D support, making
3D work on a per user basis is not very different from the way direct
rendering works today.

Supporting multiple users, one on each CRTC, has long been a feature
request from people building low end educational systems, kiosks,
Internet cafes, etc. If the entire graphics subsystem is going to get
rewritten this feature should be added.

After designing this I think you will find that the extra code that
needs to go into the kernel is minimal. You have to split the video
memory into multiple pools and keep people from accessing queues that
they don't own. Code like this is supposed to be in the kernel.

Having a multi-megabyte root priv graphics process always running is a
scary security exposure. This privileged process is not necessary and
through proper design it can be eliminated. After designing this I
think you'll find that less than 1%  of the code ends up in the driver
and the rest can run unprivileged in user space. Put the root priv
code into the device driver where it will get the scrutiny it needs.

>
>         Jeff
>
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
