Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYKUDTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYKUDTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYKUDTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:19:15 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:37328 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYKUDTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:19:14 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] loop file resizable 
To: Andrew Morton <akpm@linux-foundation.org>, tomas@slax.org,
       linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <7027.1227235078@jrobl>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org> <7027.1227235078@jrobl>
Date: Fri, 21 Nov 2008 12:19:06 +0900
Message-ID: <7464.1227237546@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hooanon05@yahoo.co.jp:
> 
> Andrew Morton:
> > Well if we're going to do this then I guess we'll need to tell the
> > util-linux people about it, as users will be needing some tool with
> > which to access the new fucntionality.
	:::

> Here is the utility named logrow.

I should left some notes here.
Several people uses truncate/ftruncate to expand the size of the backend
file. Actually I used to do it. In this version of logrow.c, I changed
it to write, in order to allocate the disk blocks.

If I issued truncate and expand the size of filesystem by xfs_growfs or
something, it would succeed. But when the filesystem which has the
backend file becomes full and the loopback mounted xfs wants more disk
blocks, it will return EIO or retry several times.
I believe it should return ENOSPC at once and changed to write garbages
and allocate the disk blocks.

Tomas, this is the point of the new version.


J. R. Okajima
