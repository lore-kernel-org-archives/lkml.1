Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZASKLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZASKLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbZASKLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:11:23 -0500
Received: from mail.memset.com ([89.200.136.113]:37134 "EHLO mail.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbZASKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:11:22 -0500
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 05:11:21 EST
To: David Wagner <daw@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
In-Reply-To: <bVsVO-15X-19@gated-at.bofh.it>
References: <bVsVO-15X-19@gated-at.bofh.it>
Date: Mon, 19 Jan 2009 09:38:07 +0000
User-Agent: slrn/pre0.9.9-102 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090119093814.BC18014CA88@irishsea.home.craig-wood.com>
From: nick@craig-wood.com (Nick Craig-Wood)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner <daw@cs.berkeley.edu> wrote:
>  Is there a way to tell what options have been applied to a currently
>  loaded kernel module?
> 
>  I'm trying to force libata to use 1.5Gbps rather than 3Gbps, so I created
>  a file /etc/modprobe.d/local containing:
>    options libata force=1.5Gbps
>  However my SATA drive gets loaded at 3Gbps.  I'm trying to figure out how
>  to debug this so that I can tell whether the option got correctly applied
>  to the libata module, and if not, how to force the SATA link to 1.5Gbps.
>  Any suggestions or ideas?
> 
>  (I can't set libata.force=1.5Gbps as a kernel argument because on my
>  Fedora kernel, libata is loaded as a module rather than built into the
>  kernel.  I can't run "modprobe libata force=1.5Gbps" by hand because
>  I've got SATA drives, so the libata module is automatically loaded before
>  I get shell access.)

I had to do this recently (under debian I ended up putting
"libata force=1.5Gbps" into /etc/modules)

You can check it is working by looking for something like this in the log

[    2.345058] ata1: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata1: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106100 irq 218
[    2.345058] ata2: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata2: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106180 irq 218
[    2.345058] ata3: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata3: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106200 irq 218
[    2.345058] ata4: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata4: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106280 irq 218
[    2.345058] ata5: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata5: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106300 irq 218
[    2.345058] ata6: FORCE: PHY spd limit set to 1.5Gbps
[    2.345058] ata6: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106380 irq 218

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
