Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYBLRA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYBLRA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbYBLRAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:00:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60741 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYBLRAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:00:18 -0500
Date: Tue, 12 Feb 2008 09:00:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080212090001.3fcc4ca0@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I just read the excellent LWN writeup of the vmsplice security thing, and that got me
wondering why this attack wasn't stopped by the CONFIG_CC_STACKPROTECTOR option... because
it plain should have been...

some analysis later.. it turns out that the following line in the top level Makefile,
added by you in October 2007, entirely disables CONFIG_CC_STACKPROTECTOR ;(
With this line removed the exploit will be nicely stopped.

# Force gcc to behave correct even for buggy distributions
CFLAGS          += $(call cc-option, -fno-stack-protector)


Now I realize that certain distros have patched gcc to compensate for their lack of distro
wide CFLAGS, and it's great to work around that... but would there be a way to NOT
disable this for CONFIG_CC_STACKPROTECTOR please? It would have made this
exploit not possible for those kernels that enable this feature (and that includes distros
like Fedora)

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
