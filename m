Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZA0NVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZA0NVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZA0NVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:21:35 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:51029 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753039AbZA0NVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:21:34 -0500
X-Spam-Virus: No
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
X-URL: <http://www.mandrivalinux.com/
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no>
	<20090104224052.GE1913@elf.ucw.cz> <20090104233052.GG22958@mit.edu>
	<200901042149.27655.rob@landley.net>
	<20090105111913.47a8d1a5@lxorguk.ukuu.org.uk>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Tue, 27 Jan 2009 14:24:27 +0100
In-Reply-To: <20090105111913.47a8d1a5@lxorguk.ukuu.org.uk> (Alan Cox's message of "Mon\, 5 Jan 2009 11\:19\:13 +0000")
Message-ID: <m2vds0vq44.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> > That would be true if the disk hardware wasn't doing a gazillion retries to 
> > read a bad sector internally (taking 5 seconds to come back and report 
> > failure), and then the darn scsi layer added another gazillion retries on top 
> > of that, and the two multiply together to make it so slow that that when you 
> > leave the thing copying the disk overnight it's STILL not done 24 hours later.  
> > Going in and cherry picking individual files looks kind of appealing in that 
> > situation.
> 
> You could of course just learn to use the functions the kernel provides.
> If you want to recover disk blocks without retrying you can do that via
> SG_IO. If you want to adjust the timeout and retry levels you can do that
> too via sysfs.

Sure but maybe the default values might be altered. I think the current
tradeoff has set the cursor way too far for retries.

I remember seeing I/O error on CDs resulting in zillions of retries on
errors on USB discs resulting in resetting the USB port again & again
for hours... (CD case is years ago, but I usually see the USB layer
trying reseting for quite a long time at least once per month)
