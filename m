Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYFMR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYFMR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYFMR4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:56:04 -0400
Received: from www17.your-server.de ([213.133.104.17]:54917 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYFMR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:56:02 -0400
Subject: Re: linux-next: Tree for June 12
From: Thomas Meyer <thomas@m3y3r.de>
To: tiwai@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080612175307.8e4e3e08.sfr@canb.auug.org.au>
References: <20080612175307.8e4e3e08.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 21:56:31 +0200
Message-Id: <1213386991.3455.9.camel@dhcppc4>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 12.06.2008, 17:53 +1000 schrieb Stephen Rothwell:

> Changes since next-20080611:
> 

Beginning with next-20080612 i've got no sound!

git bisect told me that, the offending commit is cbc5a5b7d12b4d461bff132f76abc0d4f9f3d8fc (ALSA: hda - Add bdl_pos_adj option):

I need to add the option bdl_pos_adj=0, to make sound work again, which gives this dmesg entry:

[   64.697747] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.

The sound card is:

$ cat /proc/asound/cards
 0 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfbff0000 irq 21


$ /sbin/lspci -vv -s 00:06.1
00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7250
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fbff0000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

What makes me wonder is, that the commit says:
"    The new option adds the size of the delay in frames.  As default,
    it's set to 1 -- that is, one sample delay.  Even the hardware is
    really correct, one sample delay is relatively harmless in comparison
    with reporting wrong positions."

Maybe my definition of "harmless" is not "no sound".

Would you please check this problem?

greets
thomas


