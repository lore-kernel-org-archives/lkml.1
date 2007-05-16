Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXEPVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXEPVxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXEPVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:53:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39751
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbXEPVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:53:11 -0400
Date: Wed, 16 May 2007 14:53:17 -0700 (PDT)
Message-Id: <20070516.145317.03979683.davem@davemloft.net>
To: adaplas@gmail.com
Cc: akpm@osdl.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to
 their respective subdirectories
From: David Miller <davem@davemloft.net>
In-Reply-To: <464B78BC.4080900@gmail.com>
References: <464B78BC.4080900@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Thu, 17 May 2007 05:33:48 +0800

> Move arch-specific bits of fb_mmap() to their respective subdirectories
> 
> Signed-off-by: Antonino Daplas <adaplas@gmail.com>
> ---
> Hi all,
> 
> Please let me know if there are mistakes with this patch.

Thank you for doing this work.

__sparc_v9__ means CONFIG_SPARC64, if that is not defined it's
CONFIG_SPARC32, so you could simplify this patch a lot.

1) Remove __sparc_v9__ ifdefs from asm-sparc64/fb.h
2) Define fb_mmap_required() to return 0 in asm-sparc64/fb.h
3) Define fb_mmap_required() to return 1 in asm-sparc/fb.h
4) Remove all the sparc ifdef stuff you added to linux/fb.h
5) There won't be a default fb_mmap_required() provided by
   linux/fb.h on platforms other than sparc ones, you'll need
   to provide one in order for the build to work non-sparc since
   this call is unconditional in fbmem.c:

+	if (fb_mmap_required())
+		return -EINVAL;

With those fixes:

Signed-off-by: David S. Miller <davem@davemloft.net>
