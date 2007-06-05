Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXFEXiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXFEXiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764385AbXFEXh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:37:56 -0400
Received: from main.gmane.org ([80.91.229.2]:51661 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761085AbXFEXhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:37:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <wa1ter@myrealbox.com>
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
Date: Tue, 05 Jun 2007 16:37:39 -0700
Organization: none
Message-ID: <f44s49$e64$1@sea.gmane.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-211-243.dsl.irvnca.pacbell.net
User-Agent: Thunderbird 3.0a1pre (X11/20070605)
In-Reply-To: <20070605215256.GT31565@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On Tue, Jun 05, 2007 at 11:31:46PM +0200, Mikael Pettersson wrote:
>> I can easily reproduce the problem in 2.6.22-rc4. There are no
>> sata_promise changes between rc3 and rc4, but Tejun's libata
>> polling SETXFER change was included in rc4. Reverting it makes
>> sata_promise work again for me.
> 
> Ugh.

Reverting Tejun's patch also fixed my boot failure.

00:08.0 RAID bus controller: Promise Technology, Inc. PDC20376 (FastTrak 
376) (rev 02)
         Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
         Flags: bus master, 66MHz, medium devsel, latency 96, IRQ 16
         I/O ports at d400 [size=64]
         I/O ports at d000 [size=16]
         I/O ports at b800 [size=128]
         Memory at f6800000 (32-bit, non-prefetchable) [size=4K]
         Memory at f6000000 (32-bit, non-prefetchable) [size=128K]
         Capabilities: [60] Power Management version 2

00:11.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if
  8a [Master SecP PriP])
         Subsystem: ASUSTeK Computer Inc. A7V8X / A7V333 motherboard
         Flags: bus master, medium devsel, latency 32, IRQ 255
         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
         [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
         I/O ports at a400 [size=16]
         Capabilities: [c0] Power Management version 2

The problem is that the controller can't be initialized properly, so
the kernel keeps trying every 5 seconds.  I gave up after about five
failures.  If the actual boot error messages would help I'll need to
copy them by hand -- just say the word.


