Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbYCDUGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbYCDUGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762417AbYCDUGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:06:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758683AbYCDUGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:06:40 -0500
Date: Tue, 4 Mar 2008 12:04:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>,
       dm-devel@redhat.com
Subject: Re: 2.6.25-rc regression: kernel panic on boot
In-Reply-To: <20080304193348.GC5534@suse.de>
Message-ID: <alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080304104312.457ba3a8.akpm@linux-foundation.org> <20080304193348.GC5534@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2008, Greg KH wrote:
> 
> I have a patch queued up to change the wording of this config entry to
> not say 2006, as that's not true anymore, and it should hopefully fix
> some of the confusion here.

Well, I think some of the confusion is simply from people who already 
turned it off *before* (without problems), and now just do "make 
oldconfig" or otherwise just keep it off, and it causes problems for them.

Updating the help text won't do squat, because those people won't be 
reading it - maybe they read it back when it was a new option (and it 
worked for them), but not any more.

So I would almost suggest we simply force the option back on for now. 
Then, in 2.6.26, we can make it a question again, and by that time, people 
will have it as 'y' in their config files and will now have the option to 
turn it off again.

In other words, how about just this diff?

		Linus

---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f698a5a..a36e2e2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -367,7 +367,7 @@ config RESOURCE_COUNTERS
 	depends on CGROUPS
 
 config SYSFS_DEPRECATED
-	bool "Create deprecated sysfs files"
+	bool "Create deprecated sysfs files" if EMBEDDED
 	depends on SYSFS
 	default y
 	help
