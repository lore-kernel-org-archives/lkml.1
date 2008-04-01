Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYDAIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYDAIdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYDAIdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:33:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:63460 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbYDAIdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:33:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18417.62252.520797.110925@harpo.it.uu.se>
Date: Tue, 1 Apr 2008 10:32:44 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Schmitz <schmitz@smaragd.biophys.uni-duesseldorf.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
In-Reply-To: <20080401091240.420b3aeb@core>
References: <20080331224318.4768c050@core>
	<Pine.LNX.4.44.0804010512010.22211-100000@smaragd.biophys.uni-duesseldorf.de>
	<20080401091240.420b3aeb@core>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:
 > > Sorry for the mess in core code - ist there any other way for only driveid
 > > and packet data getting swapped? And can we actually use the device mapper
 > > to byte-swap the root partition?
 > 
 > Device Mapper can certainly support that if needed - I don't think it has
 > a swab target currently but byteswapped is just a very bad crypto
 > algorithm so you can use dm crypt target as a reference. Might not be a
 > bad idea just to make the media shareable.
 > 
 > The only other way I can see to do it would be to split the ATA transfer
 > functions into two sets one for media data and one for other stuff - but
 > then how do you handle iso9660 cd ?

I had a brief look at this a little while ago, as I was looking at
the hacks Debian applies to make 2.6.x IDE work on Atari/ARAnym.
As I understood it the problem was some IDENTIFY command which needed
to not byteswap (the hack byteswaps a second time). Can't the driver
inspect the command type and choose whether to swap or not?

I had a grand plan of writing a pata_falconide libata driver, but
ran out of steam :-(
