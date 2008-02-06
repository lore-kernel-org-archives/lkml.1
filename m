Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYBFPBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYBFPBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYBFPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:00:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:11569 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYBFPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ynixem/h/QaoXD3imavJHEDFwkrQT0c19JnY06nRrI53BMpm0AOKaPeuCI3KGIv9Hv+8wzVkWgo9l4qKQqh71Gnsb8MtnBEAIkZ69Mvj0u0ae2b7e5IdXAttg8rigUXd8dkNrF/QI3Nk+z8/g9Bve3S1v/goCP3mQ3SIRF2nW7g=
Date: Wed, 6 Feb 2008 10:00:44 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
Message-ID: <20080206150043.GA6921@nineveh.local>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:42:40AM +0100, Jiri Slaby wrote:
> On 02/05/2008 11:57 PM, Tino Keitel wrote:
> > Hi,
> >
> > I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> > got the following error message from ath5k:
> >
> > ath5k_pci 0000:02:00.0: registered as 'phy0'
> > ath5k phy0: failed to resume the MAC Chip
> > ath5k_pci: probe of 0000:02:00.0 failed with error -5
>
> We failed to resume after a hardware reset here for a whole second. Is there any
> version of ath5k which worked for you (is this a regression)?

I cannot speak for Tino, but my ath5k never worked in MacBook -- it
failed the same way, and I believe the hardware was the same.  My
understanding was that it was a known bug with PCIE devices, but I got
that out of reading list archives.

>
> > Here is the lspci -vnn output:
> >
> > 02:00.0 Ethernet controller [0200]: Atheros Communications, Inc.
> > AR5006EG 802.11 b/g Wireless PCI Express Adapter [168c:001c] (rev 01)
> > 	Subsystem: Apple Computer Inc. Unknown device [106b:0086]
> > 	Flags: fast devsel, IRQ 17
> > 	Memory at 90100000 (64-bit, non-prefetchable) [disabled]
> > 	[size=64K]
> > 	Capabilities: [40] Power Management version 2
> > 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> > 	Queue=0/0 Enable-
> > 	Capabilities: [60] Express Legacy Endpoint, MSI 00
> > 	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
> > 	Capabilities: [100] Advanced Error Reporting <?>
> > 	Capabilities: [140] Virtual Channel <?>
> > 	Kernel modules: ath5k
> >
> > The same device works with madwifi:
> >
> > ath_rate_sample: 1.2 (svn r3339)
> > MadWifi: ath_attach: Switching per-packet transmit power control off
> > wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> > wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> > wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps
> > 24Mbps 36Mbps 48Mbps 54Mbps
> > wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> > wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> > wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
> > wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
> > wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
> > wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
> > wifi0: ath_announce: Use hw queue 8 for CAB traffic
> > wifi0: ath_announce: Use hw queue 9 for beacons
> > ath_pci: wifi0: Atheros 5424/2424: mem=0x90100000, irq=17
> >
> > I can also set the interface up and use iwlist ath0 scan.
>
> Hmm, I guess madwif-old-openhal doesn't work either.
>
> I suspect ath5k_hw_nic_wakeup being called before setting ah_single_chip in
> ath5k_hw_attach. Could you test the attached patch?

I cannot, as my MacBook is now broken.

--
Joseph Fannin
jfannin@gmail.com
