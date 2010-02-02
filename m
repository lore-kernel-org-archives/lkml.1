Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0BBFqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 00:46:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44019 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0BBFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 00:46:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B67BC12.4080709@s5r6.in-berlin.de>
Date: Tue, 02 Feb 2010 06:45:54 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com>
In-Reply-To: <4B676917.2080506@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> So(correct me if I'm wrong), I'm generating a 64 bit register
> and the kernel is looking for a 32 bit register causing the crash.

No, the class = read_pci_config(); if (class == ...) ... parts of the
code are entirely innocent as far as I can tell.  This is just the
FireWire--PCI chip detection.  It is the subsequent driver setup for the
chip that crashes somewhere.

When you modified that chip detection code earlier, you only prevented
crashes when your modifications ended up as "ignore all PCI devices,
also FireWire ones" == "do nothing at all".

Perhaps the bootup sequence of the x86(-64) platform was changed from
2.6.31 to .32 thus that some assumptions in init_ohci1394_dma about when
are what resources available are not true anymore.  According to your
screenshot in http://lkml.org/lkml/2009/10/27/335 the issue is about
memory allocation, not about PCI bus access.
-- 
Stefan Richter
-=====-==-=- --=- ---=-
http://arcgraph.de/sr/
