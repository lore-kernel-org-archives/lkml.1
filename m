Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbYEFVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbYEFVk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbYEFVkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:40:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbYEFVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:40:13 -0400
Date: Tue, 6 May 2008 14:39:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tony@bakeyournoodle.com (Tony Breeds)
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-Id: <20080506143936.6357e578.akpm@linux-foundation.org>
In-Reply-To: <20080424043400.GS20457@bakeyournoodle.com>
References: <20080424043400.GS20457@bakeyournoodle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 14:34:01 +1000
tony@bakeyournoodle.com (Tony Breeds) wrote:

> Current kernel builds warn about:
> drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
> drivers/video/aty/radeon_base.c:2334: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
> drivers/video/aty/radeon_base.c:2336: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
> 
> Do minimal checking of these functions and issue a warning if either
> fails.  They don't seem to be critical..

well OK, but I object to the patch title!

The point isn't to silence warnings.  It is to fix the problem which that
warning is drawing our attention to.

So I rewrote the title to "drivers/video/aty/radeon_base.c: notify user if
sysfs_create_bin_file() failed".

And your fix looks appropriate - if sysfs_create_bin_file() fails we will now get
reports of this and we can find out what kernel bug caused this to happen.

