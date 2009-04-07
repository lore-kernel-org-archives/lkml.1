Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZDGQsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZDGQsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZDGQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:47:51 -0400
Received: from www.tglx.de ([62.245.132.106]:41842 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZDGQrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:47:51 -0400
Date: Tue, 7 Apr 2009 18:45:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
cc: David Brownell <david-b@pacbell.net>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0CFFAA90C0@dlee02.ent.ti.com>
Message-ID: <alpine.LFD.2.00.0904071831550.21577@localhost.localdomain>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com> <200904051556.05368.david-b@pacbell.net> <alpine.LFD.2.00.0904070042300.21577@localhost.localdomain> <200904061849.23110.david-b@pacbell.net>
 <7A436F7769CA33409C6B44B358BFFF0CFFAA90C0@dlee02.ent.ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Narnakaje, Snehaprabha wrote:
> > And that's exactly what these patches do:  enable just such choices.
> > The $SUBJECT patch would be needed to use NAND_ECC_HW with this 4-bit
> > ECC hardware, and not be forced to "choose" the infix-OOB policy.
>
> I had looked read_page/write_page APIs of the NAND_ECC_HW mode to
> see if we can use this mode for DaVinci DM355 device.
> 
> The read_page handler for NAND_ECC_HW mode reads the data and ECC
> from hardware for each chunk. It then reads the OOB and extracts ecc
> code from it, before using the ECC from hardware and ecc code from
> OOB for data correction.
>
> On DaVinci DM355 device, we need to pass the ecc code/syndrome
> extracted from OOB area, in order to read the HW ECC for each data
> chunk. This is where we differ from NAND_ECC_HW mode.

I have to admit that I'm slightly confused. Is the below description
correct?

On write you generate the ECC via hardware and store it in the OOB
area, right ?

On read you read the oob data first and extract the ECC. Then you feed
the extracted ECC into the HW generator and read the data. Is this
correct ?

> The read_page/write_page APIs for NAND_ECC_HW_SYNDROME have the
> other problem that David mentioned - overwriting NAND manufacturers
> bad block meta data, when used with large page NAND chips. These
> APIs do not handle the "eccsteps" properly. The OOB is read/written
> after every data chunk, thus you actually have overwritten the
> factory bad block information, when these APIs handle the last data
> chunk. OOB should be read/written after the entire data (a page) is
> read/written.

Again, that is _how_ the NAND_ECC_HW_SYNDROME functions work. And if
your hardware needs a completely different mode, then we need to
analyse what's the best solution for it.

Right now the provided information is way to diffuse to do that.

You provided a patch without explaining what your hardware needs and
showing how the actual user of the modified API looks like and how the
functionality is implemented.

Thanks,

	tglx
