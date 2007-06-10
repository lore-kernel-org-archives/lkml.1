Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXFJSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXFJSzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXFJSy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:54:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7797 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753765AbXFJSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:54:56 -0400
Date: Sun, 10 Jun 2007 20:54:39 +0200
From: Carlo Wood <carlo@alinoe.com>
To: linux-kernel@vger.kernel.org
Subject: ide0=noprobe, hda=noprobe, hda=none ignored?
Message-ID: <20070610185439.GA12202@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying for months to get my box to boot faster
by ignoring the not connected hda/hdb (ide0).

ansset:~>dmesg | egrep '(noprobe|ide0|hda|hdb)'

Kernel command line: root=/dev/hde3 ro ide0=noprobe
    ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: IRQ probe failed (0xfffffdb8)
etc.

or

Kernel command line: root=/dev/hde3 ro hda=none hdb=none
    ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: IRQ probe failed (0xfffffdb8)

same for hda=noprobe hdb=noprobe

Nothing helps.

Is this a bug or not? I'd think that saying "noprobe" means
"do NOT probe" - but it probes anyway.

The documentation also tells me that =none should CERTAINLY
make it ignore the non-existant drives - but it keeps probing.

Shouldn't an explicitely added kernel parameter be taken a
little bit more serious by the kernel? Independent on whether
or not a drive is detected (or what the CMOS might think about
that), I think that the kernel should REALLY, totally ignore
an ide and/or hdX if so explicitely requested with a kernel
parameter.

Anything I missed?

-- 
Carlo Wood <carlo@alinoe.com>

PS Sorry if this is a FAQ (it seems so) -- I just can't find
   a satisfactory answer anywhere as to why explicit parameters
   like this are ignored and want to ask to change this. Or,
   I cannnot find the solution for this problem and get my
   damn ide0 NOT probed.

