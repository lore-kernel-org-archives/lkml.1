Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYJFITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYJFITT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYJFITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:19:11 -0400
Received: from toomai.ethgen.de ([85.10.201.50]:58234 "EHLO toomai.ethgen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYJFITK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:19:10 -0400
Date: Mon, 6 Oct 2008 09:19:07 +0100
From: Klaus Ethgen <Klaus@Ethgen.de>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [KERNEL] Re: [KERNEL] Re: Kernel freeze on 2.4.36.7
Message-ID: <20081006081907.GA12913@ikki.ethgen.de>
References: <20081005154113.GA8387@ikki.ethgen.de> <20081005171818.GJ24654@1wt.eu> <20081005204247.GA3781@ikki.ethgen.de> <20081005210144.GA7980@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Content-Disposition: inline
In-Reply-To: <20081005210144.GA7980@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am So den  5. Okt 2008 um 22:01 schrieb Willy Tarreau:
> > Well, thats not that true. It WAS everytime until I close all
> > applications and did sync several times before I unplug the device. When
> > I wait a view seconds after the sync the freeze is reproducible.
             ^^^^
Should mean "few".

> Sounds like the application directly attaches to the device itself and
> we have some internal pointer becoming NULL when the device disappears.

Hmm...

> > > Also, have you ever been running and older 2.4 kernel not causing this
> > > problem ?
> > 
> > I did buy the scanner only days ago. I did not use older kernels since
> > then. (I have to compile some if it is needed.)
> 
> OK, so we'll assume it's not a regression and has always been like that,
> which is the most likely.

I'm not absolutely sure but when I remember correct I did use USB
keyboard before in older ages. But I do not be absolutely sure if I test
to unplug it that time.

> OK. I see an nvidia module. Would this machine happen to run under X ?

Yes. I need to use the nvidia module to use the machine. But I do not
use that crazy window manages than kde or gnome which do some special
think with your devices hidden from the user.

> If so, did you configure X so that it directly references the HID devices ?

What do you mean with "directly"? I use evdev for mouse but the keyboard
is just normal keyboard with some Xkb settings for the layout.

> Also, could you tell us a bit more about the application, and how you have
> to proceed to avoid the problem ? Eg: quit the application then X, etc...

Just sync several times in front of unplugging the device helps. I can
reproduce the bug right after a boot without logging in under X (Just
kdm running). But if I use sync the problem is gone.

I imagine that it might be something to do with a incompatibility
between HID and one filesystem driver. I saw this issue in the past with
ext3 which was very dirty in the past.

Actually I use reiserfs, ext3, and ext2. Might it be that there is some
shared memory used between that both subsystems? Ah, and before I forget
to mention, I use the cryptoloop-jari patch to use encrypted swap and
so.

> OK. Before I ask you to do so, could you send me privately your System.map,
> a copy of /proc/ksyms and your vmlinux (not vmlinuz) ?

Yup, I will send it later. But why vmlinuX and not vmlinuZ? I thought
that this both is the same.

> Oh, and if you're running X, please also send your X config file, just
> in case.

Will follow too.

Regards
   Klaus Ethgen
- -- 
Klaus Ethgen                            http://www.ethgen.de/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBSOnJ+5+OKpjRpO3lAQL9OAf/TJe/wno/hADSMhU+euCxwZ/WjNb0rZ+J
iSv3GX7Kx7Yrk5Y6znVWmJVWOuDMrws2WCPo9mG1IvrCvIclAsoouj1nj68/TpT/
zsy14V+S/Va/2CDfDncJuucKHlXSOKB42IMDmWWJekoandarCBCPx0BgStukHcc4
jsFYKNr1nL8a77S9GDxZsvQU0L9Pxt4I0MxATI/1rrwTNnhMSLK6aMIHSZTvjBBm
7DBlnr8bzo9MzYOspMZHUddM6ZMWuYIheDiEh9s1OTNspsDlS6fKj1l75fXB6Ncz
klANfHMJXFoLOlWVEXxE/uX8/+vetMkD0wmwtWg/W2gXAivNXNeoQQ==
=38uU
-----END PGP SIGNATURE-----
