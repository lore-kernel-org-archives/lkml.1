Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZHXLWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZHXLWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZHXLWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:22:15 -0400
Received: from mx01.bfk.de ([193.227.124.2]:41246 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZHXLWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:22:14 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz>
From: Florian Weimer <fweimer@bfk.de>
Date: Mon, 24 Aug 2009 11:19:01 +0000
In-Reply-To: <20090824093143.GD25591@elf.ucw.cz> (Pavel Machek's message of "Mon\, 24 Aug 2009 11\:31\:43 +0200")
Message-ID: <82k50tjw7u.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek:

> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so.

You should make clear that the file lists per-file-system rules and
that some file sytems can recover from some of the error conditions.

> +* don't damage the old data on a failed write (ATOMIC-WRITES)
> +
> +	(Thrash may get written into sectors during powerfail.  And
> +	ext3 handles this surprisingly well at least in the
> +	catastrophic case of garbage getting written into the inode
> +	table, since the journal replay often will "repair" the
> +	garbage that was written into the filesystem metadata blocks.

Isn't this by design?  In other words, if the metadata doesn't survive
non-atomic writes, wouldn't it be an ext3 bug?

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
