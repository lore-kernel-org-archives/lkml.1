Return-Path: <linux-kernel-owner+w=401wt.eu-S1764846AbYEFVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764846AbYEFVnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYEFVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:43:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43853
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbYEFVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:43:08 -0400
Date: Tue, 06 May 2008 14:43:01 -0700 (PDT)
Message-Id: <20080506.144301.233784820.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: tony@bakeyournoodle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080506143936.6357e578.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 May 2008 14:39:36 -0700

> On Thu, 24 Apr 2008 14:34:01 +1000
> tony@bakeyournoodle.com (Tony Breeds) wrote:
> 
> > Current kernel builds warn about:
> > drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
> > drivers/video/aty/radeon_base.c:2334: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
> > drivers/video/aty/radeon_base.c:2336: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
> > 
> > Do minimal checking of these functions and issue a warning if either
> > fails.  They don't seem to be critical..
> 
> well OK, but I object to the patch title!
> 
> The point isn't to silence warnings.  It is to fix the problem which that
> warning is drawing our attention to.
> 
> So I rewrote the title to "drivers/video/aty/radeon_base.c: notify user if
> sysfs_create_bin_file() failed".
> 
> And your fix looks appropriate - if sysfs_create_bin_file() fails we will now get
> reports of this and we can find out what kernel bug caused this to happen.

The last time someone "fixed" this warning in the radeon driver,
people lost their consoles.

Just giving a heads up...
