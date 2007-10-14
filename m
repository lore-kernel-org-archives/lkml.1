Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXJNXq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXJNXq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764052AbXJNXqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:46:03 -0400
Received: from ozlabs.org ([203.10.76.45]:58130 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763715AbXJNXqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:46:00 -0400
Date: Sun, 14 Oct 2007 18:42:43 -0500
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: NO_HZ and cpu monitoring tools
Message-ID: <20071014234242.GB24519@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

When using a NO_HZ kernel on ppc64, I noticed top gives some interesting
results:

Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu5  :  1.1%us,  0.0%sy,  0.0%ni, 98.9%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st

Notice how only 2 cpus report idle time. Im guessing this happens if 
a core sleeps for longer than the update period in top. Where should
this be fixed?

It would be possible for the proc read method to add in the right number
of idle jiffies, or top could just assume no increment means 100% idle.

Anton
