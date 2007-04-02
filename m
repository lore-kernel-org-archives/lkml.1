Return-Path: <linux-kernel-owner+w=401wt.eu-S965818AbXDBUR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818AbXDBUR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXDBUR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:17:26 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:44874 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965818AbXDBURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:17:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AuxNO9sQKf89mzKpsFGYE7A7MUKuWw9qjWCwUYdNtsJCbSr5tqVnnwQLgL9QQXxlKvPuSd/dZ/1Z0DFRVDbqWE4ecMEy60+4r2aPU4I2bZ5AHYgTeztWTVmKhuJ9jAqJnEOpdKA7IyLWf9V00H5TpVygEusuDH58TGtMaSvnomc=  ;
X-YMail-OSG: dXHr0jgVM1nZFLs8TNcyKrLfW307sWHcP8Dp6xOXyLv_O_m7YlTVE.68GTo5y.qdrgVpPC5Y1Q--
From: David Brownell <david-b@pacbell.net>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Date: Mon, 2 Apr 2007 13:17:22 -0700
User-Agent: KMail/1.7.1
Cc: "Greg KH" <gregkh@suse.de>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Andres Salomon" <dilinger@debian.org>
References: <200703311455.38490.david-b@pacbell.net> <d120d5000704021310r777e1796rf2025d873404afeb@mail.gmail.com>
In-Reply-To: <d120d5000704021310r777e1796rf2025d873404afeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021317.22909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 1:10 pm, Dmitry Torokhov wrote:
> On 3/31/07, David Brownell <david-b@pacbell.net> wrote:
> > @@ -349,6 +360,13 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
> >  *     memory allocated for the device allows drivers using such devices
> >  *     to be unloaded iwithout waiting for the last reference to the device
> >  *     to be dropped.
> > + *
> > + *     This interface is primarily intended for use with legacy drivers
> > + *     which probe hardware directly.  Because such drivers create device
> > + *     nodes themselves, rather than letting system infrastructure handle
> > + *     such device enumeration tasks, they don't fully conform to the Linux
> > + *     driver model.  In particular, when such drivers are built as modules,
> > + *     they can't be "hotplugged".
> >  */
> >  struct platform_device *platform_device_register_simple(char *name, unsigned int id,
> 
> I find this comment misleading. Many of these drivers do not create
> any devices (as in /dev/xxx) but rather create underlying hardware
> abstraction objects.

When I refresh this patch, I'll make it say "create sysfs device nodes" to
make clear which type of device node (not the /dev/ kind) it's referring to.

- Dave
