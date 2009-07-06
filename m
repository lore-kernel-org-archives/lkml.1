Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZGFUEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZGFUEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZGFUEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:04:40 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47145 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZGFUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:04:39 -0400
Date: Mon, 6 Jul 2009 21:04:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090706200431.GC13638@shareable.org>
References: <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr> <19021.19842.663727.146474@samba.org> <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.63615.450348.192109@samba.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> When CONFIG_VFAT_FS_DUALNAMES is not set and a 8.3 name is created,
> force the use of the shortname=winnt option to allow for lowercase or
> uppercase prefix and extensions without using a long name.
> 
> +	unsigned opts_shortname = opts->shortname;
> +
> +#ifndef CONFIG_VFAT_FS_DUALNAMES
> +	opts_shortname = VFAT_SFN_CREATE_WINNT;
> +#endif

I'd prefer if it changes the shortname= default instead.

When mounting explicitly with shortname=mixed, this patch changes it
to shortname=winnt, which breaks compatibility when creating files on
Linux and reading on Windows 95/98/ME and devices with equivalent FAT
implementation.

I think it's ok to break that compatibility if dualnames is off,
because that's unfortunately the best available compromise.

But if shortname=mixed is explicitly requested, it can mean (and does
in some cases I've seen) that there's a reason long names are required
for lower-case 8.3 names.

-- Jamie
