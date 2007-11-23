Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXKWIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXKWIk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXKWIkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:40:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:8600 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXKWIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:40:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Tat19oKOd43ibm0fJ4/+QnRoxLZ1wXZEgmOY2MBYifA8j9HDf+s6VrTexZ6iq72Kp8a6sKEjhqWmrBJLqPQ7jkGJv+7BSRGoI44A8wEHdbCNY+/DDwckMF3PITdsJSReIHSwYrLD4cLDsxBhnMcQyNysOcV/TuEtZwJxNnrYCT4=
Message-ID: <3ae72650711230040t421af579xa92208ecbf20a0e2@mail.gmail.com>
Date: Fri, 23 Nov 2007 09:40:47 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: greg@enjellic.com
Subject: Re: PCMCIA serial_cs driver binding problems.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200711201408.lAKE8WMp001714@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711201408.lAKE8WMp001714@wind.enjellic.com>
X-Google-Sender-Auth: 02c65354bc72a64f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2007 3:08 PM,  <greg@enjellic.com> wrote:
> I'm working to sort out what appear to be issues with binding of the
> serial_cs driver to a PCMCIA wireless card (Zoom).
>
> Card works perfectly in recent 2.6.2[23] kernels if cardmgr is running
> and PCMCIA_IOCTL support is in the kernel.  The serial_cs driver
> fails, however, to bind in a pure hotplug configuration.  The hotplug
> scripts detect card insertion and load the serial_cs module but the
> driver doesn't bind to the device.
>
> The slot number (0.0 or 1.0) appears in the /sys/bus/pcmcia/devices
> directory after card insertion.  The serial_cs directory also presents
> in the /sys/bus/pcmcia/drivers directory secondary to module load.
>
> I've tried to manually echo the device number (0.0 or 1.0) into the
> /sys/bus/pcmcia/drivers/serial_cs/bind pseudo-file but nothing
> happens.  The device number is present as a binding if cardmgr frobs
> things with the pcmcia_ioctl bind commands.

Did you enable this?
  echo -n 1 > /sys/devices/pci0000:00/0000:00:1e.0/0000:15:00.0/0.0/allow_func_id_match

You can watch "udevmonitor --kernel" while doing this, to get the path and
see what events the kernel creates.

Distros usually set it automatically by udev:
  ACTION=="add", SUBSYSTEM=="pcmcia", ENV{MODALIAS}=="?*",
ATTR{allow_func_id_match}="1"

Kay
