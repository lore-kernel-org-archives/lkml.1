Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbZKDRhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbZKDRhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZKDRg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:58 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37563 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbZKDRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Options: To use MSI-X or not?
In-Reply-To: Your message of "Wed, 04 Nov 2009 11:53:18 EST."
             <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257356211_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 12:36:51 -0500
Message-ID: <14754.1257356211@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4AF1BBB3.02A1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257356211_3622P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Nov 2009 11:53:18 EST, Justin Piszcz said:

> Example, 3ware cards/Intel Audio Drivers you can use MSI-X instead of 
> having several devices use/share an interrupt.
> 
> What are the pros/cons to using MSI-X vs. having devices share an IRQ?

Cons: Sometimes, you'll find a device that claims to support MSI but in fact is
to some extent borked...

I'm the proud owner of a Dell Latitude D820, which includes this PCI:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
        Subsystem: Dell Device 01cc
        Flags: bus master, fast devsel, latency 0, IRQ 30
        Memory at efffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel

However, actually trying to enable MSI gets me this at some pseudo-random
time after booting (one for each of 7 boots):

[    4.519264] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[   22.788015] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x008f0c00
[    4.719263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[   12.497263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[  815.350265] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[  595.171267] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00171700
[    4.968263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900

(Am slightly mystified about the resets at 4 and 12 seconds - at that point,
we're not up far enough to actually try to use the audio. I suspect udev trying
to initialize the card - except sometimes it works and runs just fine with
MSI for quite some time:

[14267.701267] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[12841.892050] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
[10647.783274] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x001f1500
[15091.102034] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00171700
[20085.955293] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0700



--==_Exmh_1257356211_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8buzcC3lWbTT17ARApxUAJsGlyxiso/bJxliQdstRRE2w/qUpwCgnOii
OaRurgAthLa4DF/J6oWzS8Q=
=pjLM
-----END PGP SIGNATURE-----

--==_Exmh_1257356211_3622P--

