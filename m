Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXLFCxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXLFCxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbXLFCpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:52 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1874 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXLFCpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:51 -0500
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <47575C07.1080001@oracle.com>
References: <1196359724.22120.22.camel@localhost>
	 <20071129102400.dac158d8.randy.dunlap@oracle.com>
	 <1196361860.22120.27.camel@localhost> <474F0A68.1080809@oracle.com>
	 <1196369873.22120.69.camel@localhost> <474F28EB.20608@oracle.com>
	 <Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>
	 <1196378922.22120.72.camel@localhost>
	 <20071205160133.0766c4f5.akpm@linux-foundation.org>
	 <1196907017.10819.49.camel@localhost>  <47575C07.1080001@oracle.com>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 18:42:35 -0800
Message-Id: <1196908955.10819.64.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 18:18 -0800, Randy Dunlap wrote:
> Joe Perches wrote:
> > Maybe just eliminate the 16 or 32 byte width option and
> > force it to only 16 byte widths.
> Have you checked users (callers)?  I'm pretty sure that one of the
> callers wanted 32 and that's why it's there.

I did.  There is only 1 subsystem.  That's easy to change.

drivers/mtd/ubi/debug.c:  print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
drivers/mtd/ubi/io.c:     print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,

Long lines in the log file are not too easy to read anyway.
Using 16 byte dumps per line instead of 32 isn't painful.

It gets rid of the allocation, reduces the argument count
and makes the kernel smaller.  I think it's all good.

Every current caller would have to change though.

