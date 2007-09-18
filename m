Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXIRPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXIRPMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbXIRPMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:12:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbXIRPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:12:07 -0400
Date: Tue, 18 Sep 2007 17:12:06 +0200
From: Jan Kara <jack@ucw.cz>
To: Ville Herva <v@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918151206.GC13304@atrey.karlin.mff.cuni.cz>
References: <20070918122314.GL29062@vianova.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918122314.GL29062@vianova.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> I got a bunch of these into dmesg:
> 
> EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323880: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323882: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> 
> The kernel is 2.4.35 SMP, dual-processor. The scsi driver is Fusion MPT SCSI
> Host driver 2.05.16.
> 
> The device is /dev/sda2, root fs.
> 
> One line per each directory had dropped into dmesg each night (I think
> during updatedb) before I noticed.
  Interesting. Can you look (using debugfs) on the content of the
/usr/share/doc/ directory? It seems like parts of it have been zeroed
out...

> The directories in question have not been written to for ages:
> 
> >debugfs /dev/sda2
> debugfs:  ncheck 323888
> Inode   Pathname
> 323888  /usr/share/doc/logcheck-1.1.1
> debugfs:  ncheck 323882
> Inode   Pathname
> 323882  /usr/share/doc/dev86-0.15.5
> debugfs:  ncheck 323880
> Inode   Pathname
> 323880  /usr/share/doc/mod_put-1.3
> 
> The hardware _should_ be solid, although I can never 100% sure rule out disk
> level corruption.

									Honza
