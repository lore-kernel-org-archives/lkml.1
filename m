Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXCHQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXCHQjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXCHQjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:39:32 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:48013 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbXCHQjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:39:31 -0500
Message-ID: <45F03BFE.5060406@gmail.com>
Date: Thu, 08 Mar 2007 17:38:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [QUESTION] outl and writel endianity
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 08 Mar 2007 17:39:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

If I use outl everything seems to be OK. Is there any difference in endianity 
between outl and writel (or iowrite32, which calls writel, I guess).

When I do
outl(val, p->ibase + 4*off);
everyhting is OK, but when I do
writel(val, p->iaddr + off);
bad value is written unless I use cpu_to_be32(val) (or swap32).

this is what p struct contains:
         u32 __iomem *iaddr;
         unsigned long ibase;
and this, how it is initialized:
         p->ibase = pci_resource_start(pdev, 2);
         p->iaddr = pci_iomap(pdev, 2, 0);

What's the proper use of this? iowrite32be seems to work too.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
