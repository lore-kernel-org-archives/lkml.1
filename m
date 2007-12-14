Return-Path: <linux-kernel-owner+w=401wt.eu-S935003AbXLNAGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935003AbXLNAGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933768AbXLNAFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:05:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:21805 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574AbXLNAFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IzlU+jz/QHb2VrkXETfyQyv96R4m+g2DobiVVMLrN8xqLPMU+UpRh6akRNPwiOaBxWPuMcmJTN4dcl05/zjK8PmXcJeh6MNpp/j366xbpruC2tBZNW5vtY0EHYoTWIbd0FD36ssk/hdWL35skoG3De5f356H6AF+3FeHvx8w9aI=
Message-ID: <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
Date: Thu, 13 Dec 2007 16:05:00 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       "John Linville" <linville@tuxdriver.com>
In-Reply-To: <200712131445.39770.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712130148.22727.mb@bu3sch.de>
	 <2c0942db0712121717x59af3922na33d274cf5a8c7db@mail.gmail.com>
	 <200712131445.39770.mb@bu3sch.de>
X-Google-Sender-Auth: 02e678ca14f5b5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 5:45 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 13 December 2007 02:17:16 Ray Lee wrote:
> > Uhm, hijacking the thread a bit here, but which driver is supposed to
> > be supporting my 4309? Neither b43 nor b43legacy found my wireless,
> > and I'm not seeing its PCI ID anywhere either of those...
> >
> > 02:02.0 0280: 14e4:4324 (rev 03)
>
> The device is supported by b43.
> The PCI ID is in the SSB PCI bridge code
>
> static const struct pci_device_id b43_pci_bridge_tbl[] = {
...
>         { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },

Ah, thanks, so it is. Well, doing an `rmmod bcm43xx ; modprobe ssb
b43` gives me nothing in dmesg other than lines related to the bcm43xx
driver. iwconfig/ifconfig do not see the interface either.

<goes and reads bcm43xx-dev archives>

Okay, I had to modprobe rfkill-input and rfkill by hand, didn't
realize that. Hopefully that'll be automatic soon. Regardless, upon
doing so, and loading ssb and b43, it sees my card, but is still not
fully functional. iwconfig sees:

lo        no wireless extensions.
eth0      no wireless extensions.
tun0      no wireless extensions.
eth1      no wireless extensions.
wlan0_rename  IEEE 802.11g  ESSID:""
          Mode:Managed  Channel:0  Access Point: Not-Associated
          Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

(eth0 is ethernet, eth1 doesn't exist -- usually it's the wireless.)

`ifconfig` doesn't see eth1 or wlan0_rename.

What else might I be doing wrong? Regardless, perhaps scheduling
bcm43xx for removal in 2.6.26 is a bit premature.
