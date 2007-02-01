Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbXBAPfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbXBAPfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXBAPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:35:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:34333 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751695AbXBAPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:35:22 -0500
Date: Thu, 1 Feb 2007 16:35:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] fix usages of local_irq_save() and local_irq_disable()
Message-ID: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following series of 10 trivial patches contains two changes:

- removes local_irq_disable() on redundant places after local_irq_save()
- turns local_save_flags() + local_irq_disable() into local_irq_save()

It was quite surprising to find it on so many places. There is another gem 
in drivers/block/ataflop.c::do_fd_request():

        local_save_flags(flags);        /* The request function is called with ints
        local_irq_disable();             * disabled... so must save the IPL for later */

I am not sure if the author was aware of the fact that he commented also 
the local_irq_disable() call :) I will look into the code a bit more 
later, to see whether it just really wants to save flags, or this should 
be converted into standard local_irq_save(flags).

-- 
Jiri Kosina
