Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZA1U5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZA1U5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZA1UeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:34:24 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:49876 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZA1UeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:34:23 -0500
Date: Wed, 28 Jan 2009 12:34:21 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: speed up request_firmware()
Message-ID: <20090128203421.GC31107@ovro.caltech.edu>
References: <20090128180446.GB31107@ovro.caltech.edu> <E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru> <20090128194534.457d58cd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128194534.457d58cd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 28 Jan 2009 12:34:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 07:45:34PM +0000, Alan Cox wrote:
> > Some drivers cache firmware in memory. Doubing the amount of needed memory 
> > definitely would not be the best idea. Check drivers/net/wireless for 
> > examples.
> 
> A lot of drivers could perfectly happily exist with a simple iterator
> helper and being returned sg lists of pages. It seems that for big
> firmwares at least there is a root cause which is deeper than how you
> grow your vmalloc buffer.
> 

An sg list of pages would be perfect for my usage. I didn't want to
change an existing kernel interface, so I just made the easiest change
that worked for me.

Another thing that could be done is trimming the vmalloc() down to the
exact size needed after the firmware has finished loading. That would
still waste memory until the copy from userspace is finished, though.

I'd be happy to test patches anyone comes up with.

Thanks,
Ira
