Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXLPBkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXLPBkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 20:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXLPBkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 20:40:00 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:50649 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbXLPBj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 20:39:59 -0500
Date: Sun, 16 Dec 2007 02:39:47 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: linux-kernel@vger.kernel.org
Subject: Strange Memory Corruption Problem with Core2Duo E6700, P965
	Chipset MB and >=4GB RAM
Message-ID: <20071216013947.GA3679@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi



Yesterday i upgraded an 1 year old System from 4x1GB (32Bit, No 
Memory-Remap) to 4x2GB (64Bit, Memory-Remap)

Today i due to a lucky coincidence i discovered that i have a memory 
corruption problem.

This problem happens only with at least 4GB RAM and Memory-Remap. It 
happens with any 2 of the 4x2GB RAM-Modules and regardless of slot or 
dual or single channel configuration.

After some trying i found a way to "catch" the error. I wrote a small 
perl script to fill a tmpfs with 1MB zero-files. Then i MD5 all the 
files and discard all with the MD5-sum of a 1MB zero-file.

Here is what hexdump says about the file-content of the "bad"-file when 
it is called several times.

:/misc/badram> hexdump  bad
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00d50a0 0000 84cf 1fff fd0f 0000 0000 0000 0000
00d50b0 0000 0000 0000 0000 0000 0000 0000 0000
*
00d90a0 0000 161f 1fff 43ff 0000 0000 0000 0000
00d90b0 0000 0000 0000 0000 0000 0000 0000 0000
00d90c0 0001 0000 0000 0000 0000 0000 0000 0000
00d90d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0100000
:/misc/badram> hexdump  bad
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00d50a0 0000 84cf 1fff fd0f 0000 0000 0000 0000
00d50b0 0000 0000 0000 0000 0000 0000 0000 0000
*
00d90a0 0000 e59d 1fff 43bf 0000 0000 0000 0000
00d90b0 0000 0000 0000 0000 0000 0000 0000 0000
00d90c0 0001 0000 0000 0000 0000 0000 0000 0000
00d90d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0100000
:/misc/badram> hexdump  bad
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00d50a0 0000 84cf 1fff fd0f 0000 0000 0000 0000
00d50b0 0000 0000 0000 0000 0000 0000 0000 0000
*
00d90a0 0000 f7fb 1fff 43ff 0000 0000 0000 0000
00d90b0 0000 0000 0000 0000 0000 0000 0000 0000
00d90c0 0001 0000 0000 0000 0000 0000 0000 0000
00d90d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0100000
:/misc/badram> hexdump  bad
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00d50a0 0000 84cf 1fff ff03 0000 0000 0000 0000
00d50b0 0000 0000 0000 0000 0000 0000 0000 0000
*
00d90a0 0000 df3b 1fff 43ff 0000 0000 0000 0000
00d90b0 0000 0000 0000 0000 0000 0000 0000 0000
00d90c0 0001 0000 0000 0000 0000 0000 0000 0000
00d90d0 0000 0000 0000 0000 0000 0000 0000 0000
*
0100000

Strange is that some parts are static and other parts change.

Kernel is 2.6.23.11.
Kernel is 64Bit/x86-64, Userspace is 32bit. I only need the RAM for a 
huge ramdisk, so i don't need 64bit userspace.

Can anybody help me with this problem?





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

