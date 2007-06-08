Return-Path: <linux-kernel-owner+w=401wt.eu-S967698AbXFHKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967698AbXFHKMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967530AbXFHKMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:12:12 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35929 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937670AbXFHKMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:12:10 -0400
Message-ID: <46692AB6.1090604@gmail.com>
Date: Fri, 08 Jun 2007 12:08:54 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <20070604114110.0b88fe7a.akpm@linux-foundation.org> <4664632C.3050502@shadowen.org> <46646317.2080206@gmail.com> <466921F0.9020609@shadowen.org>
In-Reply-To: <466921F0.9020609@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2007 11:31 AM, Andy Whitcroft wrote:

> Ok, the latest version 0.04 is released and I have also put up the
> complete script at:
> 
>   http://www.shadowen.org/~apw/public/checkpatch/checkpatch.pl-0.04
> 
> Previous versions are also there.

Thank you. False positive:

	do not use assignment in condition
	#809: FILE: drivers/cdrom/mitsumi.c:766:
	+       while ((req = elv_next_request(q))) {

Doing an assignment in a while (or for) condition like that makes perfect 
sense. The check should probably be limited to if conditions -- you can 
always split those.

Next:

	struct mutex definition without comment
	#173: FILE: drivers/cdrom/mitsumi.c:130:
	+	struct mutex mutex;

Going overboard. It's the only locking primitive in the driver; the only 
comment that could be added is something like "used for mutual exclusion" 
which firmly falls into the "i++; /* increase i */" category. A bit further 
on up in the driver, a:

	/*
	 * LOCKING: mutex_lock(&mcd->mutex)
	 */

is present just before the functions that need to be called with it held 
(all, basically). I'd suggest simply dropping this check as its intention is 
not something that can be usefully automated I feel. The tree would end up 
with tons of useless comments that are there just to shut up the script.

And next a ton of:

	labels should not be indented
	#249: FILE: drivers/cdrom/mitsumi.c:206:
	+  out:

This driver is putting two spaces in front of labels, as explained here:

	http://lkml.org/lkml/2007/6/5/61

I do agree that putting them level aligned is a _significantly_ different 
style, so perhaps it wants to warn if a label is not within the first indent 
level (column 0-7) but if even that's contentious then this check should 
perhaps go completely as well. One or two spaces, four for all I care, can 
be considered a personal preference I feel.

Rene.

