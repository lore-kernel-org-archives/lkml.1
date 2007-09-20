Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbXITWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbXITWBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXITWBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:01:23 -0400
Received: from www.osadl.org ([213.239.205.134]:54764 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbXITWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:01:23 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>
In-Reply-To: <200709202354.42557.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <1190322532.3085.42.camel@chaos>
	 <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
	 <200709202354.42557.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 00:01:20 +0200
Message-Id: <1190325680.3085.73.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Thu, 2007-09-20 at 23:54 +0200, Rafael J. Wysocki wrote:
> > Hmm. This is close to the ordering we have in STR too.
> > 
> > I have some dim memory of there being some ACPI reason why it had to be 
> > done that way.
> 
> Yes.  We're executing _INI from the CPU initialization code and that shouldn't
> be done after _WAK, which is called from platform_finish().

If I tear down CPU#1 right before I tell the kernel to hibernate, then
the box must explode in the same way. It does not. On none of 4 tested
laptops. 

Of course only the jinxed VAIO one exposes the "please press a key
problem".

I need to follow down the swsusp_suspend() code path to figure out, why
this breaks the box.

	tglx


