Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbYGRWSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbYGRWSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbYGRWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:47960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYGRWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:36 -0400
Date: Fri, 18 Jul 2008 15:15:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [patch 0/3] fastboot patches series 1
Message-ID: <20080718151524.5ef9e29b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this 3 patch series introduces the concept of "asynchronous initcalls".
This is a new initcall level (6a) that has the following semantics:
1) Level 6a gets run asynchronously from the regular "driver" initcalls
2) Level 6a starts after level 5 (fs_initcall). 
3) Within the 6a category, the initcalls are processed sequentially;
   there is no parallelism between them. The parallelism is more
   like a bottom halve than it is like a softirq this way.
   This is a nice property since it leads to predictable device ordering
   while being able to move various pieces out of the critical boot path
4) The kernel will synchronize at the end of all initcalls to insure
   that we don't free initmem until all this is done (trust me, we need
   this)

With these 3 patches I managed to shave off 0.4 seconds off my kernel
boot (this may sound little, but it's a reduction from 1.9 seconds to a
little under 1.5 seconds, which is significant both compared to the
kernel boot time as well as the full distro boot time on this box)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
