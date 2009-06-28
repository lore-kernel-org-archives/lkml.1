Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZF1MhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZF1MhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZF1MhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:37:03 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64835 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1MhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WLcoffMmk9P3efpwi+mmZBiEg0EPN+DwbJCDD3bNK/MnkGYNwmtjJkBOow3eUi00+0
         fv5HkizbCyhBVecOhajYHiueKO8Sh4Gl944WxaAlsA4KAbHYf0R8XMXGQdfY5PyTDiJT
         ZxTiD4sQlIPXzXHiY3n3EY14CQg3NHaoamsmg=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Sun, 28 Jun 2009 14:37:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <ac3eb2510906280337s57f5a48kc487a85d259f83dd@mail.gmail.com>
In-Reply-To: <ac3eb2510906280337s57f5a48kc487a85d259f83dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281437.00329.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 12:37:28 Kay Sievers wrote:
> On Sun, Jun 28, 2009 at 08:21, Alberto Gonzalez<alberto6674@gmail.com> 
wrote:
> > I have recently upgraded my kernel to 2.6.30 and I've noticed that at
> > some point (randomly), udevd would start using a lot of CPU time. Killing
> > the process and starting it with --debug option prints these messages
> > when the problem starts:
> >
> > [22652] event_queue_insert: seq 168515 queued, 'change' 'drm'
>
> Care to run:
>   udevadm monitor
> and provide the output of the event sequence dump?

This is what I got wen the problem finally came back (it happens randomly, this 
time I triggered it by running glxgears, but it can happen for other reasons 
and none of them triggers it automatically):

KERNEL[1246192153.094553] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.094734] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.095273] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.095498] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.095665] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.095808] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.096463] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
KERNEL[1246192153.099394] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.103806] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.111549] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.120800] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.127997] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.135699] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.143440] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.151183] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.157421] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.163320] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.170793] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)
UDEV  [1246192153.178593] change   /devices/pci0000:00/0000:00:02.0/drm/card0 
(drm)


So just an endless loop of the same message again and again.

Thanks,
Alberto.
>
> Kay

