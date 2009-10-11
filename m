Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZJKXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZJKXJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZJKXJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:09:18 -0400
Received: from lo.gmane.org ([80.91.229.12]:34854 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZJKXFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:05:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nick Bowler <nbowler@draconx.ca>
Subject: Re: [Regression, bisected] Transmit failure in et131x.
Date: Sun, 11 Oct 2009 23:00:23 +0000 (UTC)
Message-ID: <loom.20091012T004346-812@post.gmane.org>
References: <20091008140805.GA21535@emergent.ellipticsemi.com> <20091009112016.4fb07eb7@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 99.240.144.239 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090912 Gentoo Shiretoko/3.5.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan <at> lxorguk.ukuu.org.uk> writes:
> Please test the following if you would.
> 
> If it doesn't work see if you can tell from the other end and tcpdump
> if the receiver or sender side dies, and let me know if you are using
> 10, 100 or Gbit and if you have the mtu set over 1500.

Thanks a lot for your help.  Alas, this does not resolve the issue.
Using tcpdump indicates that receive continues to work while transmit
fails.

I was using gigabit, but the problem persists when I run at 100mbit.
The MTU setting remains at the default 1500 bytes.

In case it's useful, here's the lspci -nv output for my card:

02:00.0 0200: 11c1:ed00 (rev 02)
        Subsystem: 11c1:ed00
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fd400000 (64-bit, non-prefetchable) [size=2M]
        Expansion ROM at fd7e0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Express Endpoint, MSI 00
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Count=1/1
Enable-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSVoil-
                UEMsk:  DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF+
MalfTLP+ ECRC+ UnsupReq+ ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP+ Rollover- Timeout+ NonFatalErr-
                CESta:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [130] Virtual Channel <?>
        Capabilities: [14c] Device Serial Number d9-29-03-fe-ff-3b-13-02
        Kernel driver in use: et131x
        Kernel modules: et131x


