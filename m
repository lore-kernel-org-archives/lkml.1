Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922Ab0AKTRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0AKTRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887Ab0AKTRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:17:33 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:60598 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0AKTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uXjofTt4J9d66ca6ShR6OofeNqNSIfLI17jTGz2ahMuOytjcCiNwd6TXiwtustVjkt
         YZMwN4k/bqbs6OhFwrUMVnDoLv0BwIBBYxTjoIrMWE4OxxhexwZuGl3TJKNbv7O5EHzU
         10cEHKOfk9NmzJsQ0FOqZVlZFIwgYPUa/iINc=
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20100111140255.GA1416@ucw.cz>
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>
	 <20100111140255.GA1416@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 21:17:28 +0200
Message-Id: <1263237448.30988.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:05 +0100, Pavel Machek wrote:
> On Fri 2010-01-08 13:43:47, H. Peter Anvin wrote:
> > On 01/08/2010 01:33 AM, Karel Zak wrote:
> > > 
> > > fdisk:
> > >    - the fdisk command aligns newly created partitions to minimum_io_size
> > >      boundary ("minimum_io_size" is physical sector size or stripe chunk
> > >      size on RAIDs).
> > > 
> > >    - the fdisk command supports disks with alignment_offset now.
> > > 
> > 
> > I think we should align, by default, much more aggressively than that --
> > because frequently we just don't know what the real physical alignment
> > is (think of flash media, which uses large erase blocks underneath.)
> 
> Flash has special mapping layer, and does not care (SD/MMC), or is a
> raw nand and can't be used as block device (smartmedia).

MMC does care, and we measured it, non-4KiB aligned writes were
noticeably slower on real eMMC and some MMC cards. I cannot remember the
numbers, but I vaguely recall something like 11%.

So the first statement is incorrect. It really does matter. E.g., we
observed that FAT FS was slower if the partition did not start from 4KiB
boundary.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

