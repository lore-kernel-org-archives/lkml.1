Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXIRX2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXIRX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXIRX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:28:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbXIRX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:28:39 -0400
Date: Tue, 18 Sep 2007 16:27:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <46F05A74.2000005@garzik.org>
Message-ID: <alpine.LFD.0.999.0709181625500.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org> 
 <46F0332D.3050704@garzik.org> <1190154053.6403.125.camel@localhost.localdomain>
 <46F05A74.2000005@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Jeff Garzik wrote:
> 
> Easy enough... 'pcimap' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

This is wrong.

You must not put it in lib/iomap.c, since that file is only compiled for 
architectures that use CONFIG_GENERIC_IOMAP.

So you need to put it in some *generic* PCI place, like drivers/pci/pci.c 
or similar.

		Linus
