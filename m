Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZGKUxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZGKUxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZGKUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:53:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZGKUxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:01 -0400
Date: Fri, 10 Jul 2009 18:21:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
Message-ID: <20090710162105.GA1469@ucw.cz>
References: <49FEB572.4010909@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FEB572.4010909@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-04 13:29:22, Michael Tokarev wrote:
> Is there any reason why 32-bit uswsusp &Friends does not work
> on 64bits kernel?
>
> For one, 32bits s2disk produces the following when trying to
> suspend:
>
>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
>
> this is coming from:
>
>     error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);
>     if (error && !offset)
>             error = ioctl(dev, SNAPSHOT_SET_SWAP_FILE, blkdev);
>
> but I guess (just guess!) that other SNAPSHOT_* operations will
> also fail the same way.
>
> Is there a reason why those are not in compat_ioctl?

Lazyness...?

Patch would be welcome. On 4GB machine, running 64bit kernel (but
staying with 32bit userland) makes sense...


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
