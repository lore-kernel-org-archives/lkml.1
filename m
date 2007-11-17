Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbXKQQBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbXKQQBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXKQQB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:01:28 -0500
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:43528 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbXKQQB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:01:27 -0500
Message-ID: <473F0FE0.3010501@tragetaschen.dyndns.org>
Date: Sat, 17 Nov 2007 16:59:28 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Bogus PCI vendor ID
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-RZG-AUTH: iaL9KxG65sFyH/NRHEm13ZpWIsASIz2sPdozvvewVL8dKwU=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with two of my PCI devices showing the wrong PCI vendor
ID (0001) in vanilla kernels.

My system currently runs a 32 bit x86 kernel built from ubuntu sources
2.6.20.3-ubuntu1. This is the only kernel I have found so far that shows
the correct PCI IDs:

~ # lspci -n
00:00.0 0600: 1002:7930
00:02.0 0604: 1002:7933
00:06.0 0604: 1002:7936
00:12.0 0106: 1002:4380
00:13.0 0c03: 1002:4387
00:13.1 0c03: 1002:4388
00:13.2 0c03: 1002:4389
00:13.3 0c03: 1002:438a
00:13.4 0c03: 1002:438b
00:13.5 0c03: 1002:4386
00:14.0 0c05: 1002:4385 (rev 13)
00:14.1 0101: 1002:438c
00:14.2 0403: 1002:4383
00:14.3 0601: 1002:438d
00:14.4 0604: 1002:4384
01:00.0 0300: 10de:0193 (rev a2)
02:00.0 0200: 11ab:4364 (rev 12)
03:02.0 0c00: 104c:8024

I tested several vanilla kernels: 2.6.23.1, 2.6.23, 2.6.22, 2.6.21 and
somewhere between 2.6.20 and 2.6.21 via bisect. There, the output of
lspci is as follows:

~ # lspci -n
00:00.0 0600: 1002:7930
00:02.0 0604: 1002:7933
00:06.0 0604: 1002:7936
00:12.0 0106: 1002:4380
00:13.0 0c03: 1002:4387
00:13.1 0c03: 1002:4388
00:13.2 0c03: 1002:4389
00:13.3 0c03: 1002:438a
00:13.4 0c03: 1002:438b
00:13.5 0c03: 1002:4386
00:14.0 0c05: 1002:4385 (rev 13)
00:14.1 0101: 1002:438c
00:14.2 0403: 1002:4383
00:14.3 0601: 1002:438d
00:14.4 0604: 1002:4384
01:00.0 0300: 0001:0193 (rev a2)
02:00.0 0200: 0001:4364 (rev 12)
03:02.0 0c00: 104c:8024

Note the two vendor IDs 0001 for 01:00.0 and 02:00.0.

Since these two devices are my graphics card (PCI express) and network
card (builtin) respectively I have quite some trouble running my system
without the right vendor IDs ;-)
Can this be fixed?

Regards
Kai

-- 
This signature is left as an exercise for the reader.

