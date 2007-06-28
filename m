Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbXF1RWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbXF1RWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbXF1RWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:22:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22505 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXF1RWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:22:40 -0400
Date: Thu, 28 Jun 2007 10:24:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       perex@suse.cz, sam@ravnborg.org
Subject: Re: [PATCH -mm] ALSA portman2x4 section mismatch
Message-Id: <20070628102438.cafa1b41.randy.dunlap@oracle.com>
In-Reply-To: <s5h3b0dg1fr.wl%tiwai@suse.de>
References: <20070626153013.264f5a92.randy.dunlap@oracle.com>
	<s5h3b0dg1fr.wl%tiwai@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 12:02:32 +0200 Takashi Iwai wrote:

> At Tue, 26 Jun 2007 15:30:13 -0700,
> Randy Dunlap wrote:
> > 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > FIx section mismatch when CONFIG_HOTPLUG=n:
> > 
> > WARNING: sound/built-in.o(.exit.text+0x271): Section mismatch: reference to .init.text:snd_p
> > ortman_unregister_all (between 'snd_portman_module_exit' and 'alsa_mpu401_uart_exit')
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I applied it to ALSA tree now because it's the simplest way to fix
> this warning.  But, I'm still wondering whether it was really wrong.
> 
> The function snd_portmap_unregister_all() is called both from the
> module init and exit functions.  Would the module_exit function be
> called even CONFIG_MODULE=n ?

No, it's not called when the driver is built-in.

> If not, __init_or_module should be
> correct since the function is called only from module_init.

[adding Sam to cc:]

I see.  So to try to summarize:

When CONFIG_MODULES=n, __exit functions can be allowed to reference
__init functions since the __init functions won't be called because
the __exit functions are not invoked.

Does that sound correct?  Can & should modpost add this knowledge?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
