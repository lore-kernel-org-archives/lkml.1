Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbXL1AVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbXL1AVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXL1ASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:18:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52439 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbXL1ASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:18:44 -0500
Date: Thu, 27 Dec 2007 18:18:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-reply-to: <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Message-id: <477440CF.1090807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> But as mentioned, there were other reports too of the exact same bug (with 
> different PCI devices, but the same "vendor == 0001" bogosity).
> 
> Googling for
> 
> 	lspci "Unknown device 0001:" mmconfig
> 
> shows reports like these:
> 
> 	http://lkml.org/lkml/2007/10/29/500
> 	http://madwifi.org/ticket/1587
> 	http://www.nvnews.net/vbulletin/showthread.php?t=103271
> 	http://naoya.g.hatena.ne.jp/naoya/20070529/1180436756
> 	http://bbs.archlinux.org/viewtopic.php?id=34321
> 	...
> 
> which all seem to be due to this same bug with different cards (but the 
> common theme seems to be an ATI northbridge).

This isn't an example of a per-device breakage, though. It only shows up 
on some devices, but the cause is apparently the chipset. Those devices 
work fine on other boards.

As mentioned later, it appears that CRS stuff might be related to this 
problem, but if it couldn't be fixed, I think the only sane solution 
would be to blacklist MMCONFIG support on that chipset.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

