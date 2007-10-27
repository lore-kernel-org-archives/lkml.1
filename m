Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXJ0V6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXJ0V6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJ0V5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:57:52 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:50073 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXJ0V5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:57:51 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2007 17:57:51 EDT
Date: Sun, 28 Oct 2007 00:45:01 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@sienet.hu>
X-X-Sender: szaka@dhcppc2
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Mike Waychison <mikew@google.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
In-Reply-To: <E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
Message-ID: <Pine.LNX.4.61.0710272338450.10261@dhcppc2>
References: <20071026233732.568575496@crlf.corp.google.com>
 <E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Oct 2007, Anton Altaparmakov wrote:

> And another of my pet peeves with ->bmap is that it uses 0 to mean "sparse"
> which causes a conflict on NTFS at least as block zero is part of the $Boot
> system file so it is a real, valid block...  NTFS uses -1 to denote sparse
> blocks internally.

In practice, the meaning of 0 is file system [driver] dependent. For 
example in case of NTFS-3G it means that the block is sparse or the file is 
encrypted or compressed, or resident, or it's the $Boot file, or an error 
happened.

Thankfully the widely used FIBMAP users (swapon and the ever less used 
lilo) are only interested in the non-zero values and they report an error 
if the driver returns 0 for some reason. Which is perfectly ok since both 
swaping and Linux booting would fail using a sparse, encrypted, compressed, 
resident, or the NTFS $Boot file. 

But in real, both swap files and lilo work fine with NTFS if the needed 
files were created the way these softwares expect. If not then swapon or 
lilo will catch and report the file creation error.

Afair, somebody is doing (has done?) an indeed much needed, better 
alternative. Bmap is legacy, thank you Mike for maintaining it.

	Szaka

--
NTFS-3G Lead Developer:  http://ntfs-3g.org
