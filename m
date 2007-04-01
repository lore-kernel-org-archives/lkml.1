Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDADWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDADWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 23:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXDADWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 23:22:19 -0400
Received: from NEUROSIS.MIT.EDU ([18.95.3.133]:57611 "EHLO neurosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXDADWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 23:22:19 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 23:22:19 EDT
Date: Sat, 31 Mar 2007 20:03:16 -0700
From: Jim Paris <jim@jtan.com>
To: Aaron Lehmann <aaronl@vitelus.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Silent corruption on AMD64
Message-ID: <20070401030315.GA24080@jim.sh>
References: <20070401012736.GT15189@vitelus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401012736.GT15189@vitelus.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Lehmann wrote:
> I discovered a reproducible way of causing silent file corruption.
...
> 1. Heavy Ethernet load (nc remotehost < /dev/zero)
> 2. Heavy disk write load on any non-sata_sil drive (cat /dev/zero > /path)
> 3. Heavy disk read load on any other drive (tar c /path | cat > /dev/null)

Since it shows up under heavy load that includes unrelated devices, I
think ruling out hardware problems is important.  Some suggestions:

- Use mcelog to see if you're getting any machine check exceptions
  that would indicate hardware error: http://freshmeat.net/projects/mcelog/

- Use the edac module to turn on pci parity and memory error checks:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/drivers/edac/edac.txt

- Run memtest86+ for several loops to make sure your RAM is ok

- Try moving the SiI card to a different slot

- Try running the SATA drives from a separate power supply

- Move disks and cables around to see whether the problem follows the
  disks, the cables, or the controllers

- Try enabling the "spread spectrum" clock option in your BIOS to
  reduce EMI

-jim
