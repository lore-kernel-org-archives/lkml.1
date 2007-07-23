Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXGWBCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXGWBCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763893AbXGWBCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:02:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41526 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757675AbXGWBCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:02:39 -0400
Date: Mon, 23 Jul 2007 03:02:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jeremy@xensource.com, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: xenbus_xs.c: use-after-free
Message-ID: <20070723010204.GT26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following use-after-free
in drivers/xen/xenbus/xenbus_xs.c:

<--  snip  -->

...
static int process_msg(void)
{
...
                if (IS_ERR(msg->u.watch.vec)) {
                        kfree(msg);
                        err = PTR_ERR(msg->u.watch.vec);
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

