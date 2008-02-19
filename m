Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYBSWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYBSWwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYBSWv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:51:59 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:43180 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYBSWv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:51:58 -0500
Message-ID: <47BB5D82.6070806@freescale.com>
Date: Tue, 19 Feb 2008 16:51:46 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Difference between vmlinux and vmlinux.bin
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to write an ELF loader for a PowerPC vmlinux, and I've come across 
something I don't understand.

In vmlinux, there are two Program Segments, the first of which is PT_LOAD.  What 
is the difference between the block of data inside this section, and 
vmlinux.bin?  I thought that vmlinux.bin is nothing more than the PT_LOAD 
section of vmlinux.  However, when I do a memcmp, there is a difference at 
offset 3080192 (vmlinux.bin is 4874532 bytes long):

memcmp @ 3080192 125 != 31
32 bytes @ 412f0000:

7d 20 00 28 31 29 ff ff 7d 20 01 2d 40 a2 ff f4
2f 89 00 00 41 9e 01 9c 7f e3 fb 78 4b d7 b0 75
32 bytes @ 42300000:

1f 8b 08 08 b7 e7 7a 44 00 03 62 75 73 79 62 6f
78 2d 31 2e 31 2e 33 2e 69 6d 67 00 ec 5d 7d 74

So when Kbuild creates vmlinux.bin, what does it do besides extract the PT_LOAD 
segment?

-- 
Timur Tabi
Linux kernel developer at Freescale
