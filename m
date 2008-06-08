Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYFHKct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYFHKct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYFHKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:32:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:52555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbYFHKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=NkPN6gC2Kt9jPpK1WwGBjVvWsfaA0l8oXUMnR5kVIgYQ82hKkHdMPOTG8cgZmGcN4p
         Npk8tYOeVXre0KXWazkPjV1ELtAHS4jWCE9m2gGFPXTf9lZ3D0Jryiy4tbxtSJBgdO8X
         YS+Qc4vd0E1OeCLFP6NFs+z3d5gkf43RpU3KI=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Date: Sun, 8 Jun 2008 12:42:54 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080601193000.GA3056@ime.usp.br> <20080608001143.GB10775@ime.usp.br> <20080608010207.GA11086@ime.usp.br>
In-Reply-To: <20080608010207.GA11086@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081242.54896.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > > >From what I am seeing, it looks like the bug mentioned in
> > > > <http://bugzilla.kernel.org/show_bug.cgi?id=9388>, but I don't get the
> > > > stack trace that is present there and I'm just trying to use WEP
> > > > instead of WPA or anything fancier.
> > > 
> > > Did you apply this patch?
> > > 
> > > 	http://bugzilla.kernel.org/attachment.cgi?id=14384
> > 
> > No, I did not. Is it still relevant with -rc4 or with -rc5? I still get the
> > same problem with -rc5 (but I will have to test it a bit more with -rc5).
> 
> Unfortunately, this patch won't even apply with 2.6.26-rc5 as the code
> seems to have changed a lot between that date and today. For instance,
> there doesn't seem to exist a function called "rt2500usb_config_mac_addr"
> in the rt2x00 directory (just did a grep on my unconnected iBook).

That patch was a bugfix for 2.6.25. The bug it fixed isn't present in the 2.6.26 cycle.

> > Just as a refresher:
> > 
> > * I can set everything on the iBook with the wireless key plugged;
> > * The wireless key *sees* the AP, even with encryption (that is, it grabs
> >   the MAC address of the AP, it (sometimes) shows me the signal strength,
> >   and if I issue "iwconfig wlan0 ap any", I see both the led of the
> >   wireless key blink and an increase of amount of data transmitted and
> >   received with "ifconfig wlan0");
> > * With everything set this way, if I do "dhclient wlan0", it doesn't get a
> >   lease from the AP---actually, despite the fact that it is possible to see
> >   the other point, dhclient goes, after some attempts of getting a lease,
> >   to background, but no address is ever gotten;
> > * Just to rule out possible problems with something sent to the address
> >   255.255.255.255 (which is reported as being done by dhclient), I tried to
> >   configure the address by hand via ifconfig, but, for instance, I couldn't
> >   ping my AP (which I can from other computers with a rt61pci driver and a
> >   PCMCIA connection);
> > * As I mentioned above, I have no problems with the rt61pci driver, but the
> >   USB one doesn't seem to work (unfortunately, the iBook does not have a
> >   PCMCIA slot). With a notebook with an on-board Intel wireless card, I
> >   *also* don't have any problems.
> > 
> > Well, thanks, for the help so far. I hope that we can solve this issue
> > quite soon, as I need this iBook for work.
> > 
> > I am willing to help as much as I can and test anything (even something
> > that might be "experimental"). I think that this is as good a tester that
> > you can get, right? :-)
> 
> Again, I am willing to test any "intrusive" change as I still don't have
> valuable data on that machine. BTW, I have firmware from Debian's
> ralink-firmware package (which should be what ralink has released)
> installed on this machine.
> 
> I don't know if the firmware is needed in my case or not, though (my USB
> adaptor is a D-Link DWL-G122 H/W Ver. B1, F/W Ver.: 2.03---took that info
> from the back of the stick).

Which driver is actually being used? rt2500usb or rt73usb?
Also what was the last kernel version on which the driver worked for you?

If there was a last known working kernel, could you download the debugfs script:
	http://rt2x00.serialmonkey.com/phpBB/download/file.php?id=1969
enable debugfs and MAC80211_DEBUGFS and RT2X00_LIB_DEBUGFS in your kernel,
and run the script to dump all registers from the hardware to a file?

Please do this for both the working kernel as the non-working kernel so I can
see if there is a register initialization problem which could have been triggered
by an endian-problem.

Ivo
