Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZESSaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZESSaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZESS36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:29:58 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:37626 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZESS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:29:57 -0400
Date: Tue, 19 May 2009 20:29:28 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090519182928.GA8172@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <200905172135.10136.bzolnier@gmail.com> <20090518191207.GA7531@wanza.invalid> <200905191719.35543.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905191719.35543.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: Gt5rjvZOrhcMH28tkA8v5MixI6xpzEtJCYD2FDQ7-8AHMnsfhg75WZ-oDac+smDQHG
X-TOI-MSGID: 6fcff86c-d959-4d10-b067-5b273669efe3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 19, 2009 at 05:19:35PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Subject: [PATCH] ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices

I'm sorry, but that also generated a panic, looking identical to the
behaviour as for the unpatched 2.6.30-rc6.

After booting the patched kernel, the syslog file showed:

  hdc: UDMA/66 mode selected

"hdparm -I" reported that the drive was set to "udma4". On accessing the DVD,
the kernel panicked. Here's the main output from netconsole:

  hdc: cdrom_decode_status: error=0x40 <3>{ LastFailedSense=0x04 }
  ide: failed opcode was: unknown
  hdc: DMA disabled
  ------------[ cut here ]------------
  kernel BUG at drivers/ide/ide-io.c:872!
  invalid opcode: 0000 [#1]
  last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/ide1/1.0/block/hdc/size

After booting the kernel and before doing the test I had checked with
"uname -a" that this really was the newly compiled kernel. After reboot I
checked that ide-iops.o existed and had a modification time later than the
moment I applied your patch. Also, the new vmlinuz is 64 bytes shorter than
the unpatched one. Therefore I don't think I made some silly mistake which
led to the patch being ignored.

The offer for testing patches remains open :-).

Regards,
Martin Lottermoser
--
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
