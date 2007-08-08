Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbXHHWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbXHHWgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXHHWgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:36:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXHHWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:36:30 -0400
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bill Nottingham <notting@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20070808222206.GA12375@nostromo.devel.redhat.com>
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org>
	 <46B8E773.5020406@redhat.com>
	 <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
	 <20070808193220.GB5001@nostromo.devel.redhat.com>
	 <1186603327.3584.12.camel@lov.localdomain>
	 <20070808222206.GA12375@nostromo.devel.redhat.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 00:39:35 +0200
Message-Id: <1186612775.4591.13.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18cNQq6h4V8/UPwaxS/zL69B/0VU66/hbOZRh5
 LiXKDtCHvShJxN3NPagRwMuLBOJ4+kVu1PqODFsCkPsqqHwYgX
 XqTUvJysjofJnmNZEA+BrPYNIrK2DGD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 18:22 -0400, Bill Nottingham wrote:
> Kay Sievers (kay.sievers@vrfy.org) said: 
> > Ah, ok, makes sense. Yeah, that weird "platform devices loads itself by
> > the name" thing got disabled in the platform subsystem. It caused
> > modprobe loops for other devices.
> > 
> > The whole idea of issuing MODALIAS with plain module names instead of
> > aliases can't really work, but the platform maintainer didn't like to
> > use the usual aliases and the matches in the modules, for a reason I
> > didn't understand while we talked about the problem last time.
> 
> So, the solution is for the platform device to issue a random modalias
> that pcskpr exports?

I would still like to see "MODALIAS=platform:<string>" exported by the
bus, and matching aliases the modules, just like every other subsystem
does.

Like SCSI, with the "artificial" aliases for the modules it wants to
autoload:
  $ /sbin/modinfo sd_mod
  ...
  alias:          scsi:t-0x0e*
  alias:          scsi:t-0x07*
  alias:          scsi:t-0x00*
  ...

  $ cat /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/modalias
  scsi:t-0x00

That way you would get full control over the loading or blacklisting
with module-init-tools config files, which doesn't work with direct
module name requests, and no magic in the bus code or the drivers would
be needed.

Kay

