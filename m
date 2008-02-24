Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYBXAgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYBXAgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYBXAgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:36:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYBXAgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:36:07 -0500
Subject: Re: jffs2: -ENOSPC when truncating file?!
From: David Woodhouse <dwmw2@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <20080223235742.GE2202@elf.ucw.cz>
References: <20080223235742.GE2202@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 09:36:07 +0900
Message-Id: <1203813368.5771.174.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 00:57 +0100, Pavel Machek wrote:
> Hi!
> 
> I'm trying to free space by truncating big file, and I get:
> 
> root@fic-gta01:~# ls -al gps.nmea 
> -rw-r--r--    1 root     root      2332070 Feb 19 22:13 gps.nmea
> root@fic-gta01:~# > gps.nmea 
> -sh: cannot create gps.nmea: No space left on device
> root@fic-gta01:~# rm gps.nmea
> root@fic-gta01:~# > gps.nmea
> root@fic-gta01:~# 

You need to write a log entry indicating the new length of the file.
There is no space for new log entries.

There is a special case for removal -- 'rm gps.nmea' would work. Perhaps
we should add a special case for truncation too, so that it can also use
the extra pool of free space.

-- 
dwmw2

