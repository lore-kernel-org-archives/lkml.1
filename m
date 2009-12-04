Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZLDUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZLDUbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZLDUbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:31:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45758 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbZLDUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:31:38 -0500
Date: Fri, 4 Dec 2009 21:31:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@ucw.cz>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091204203143.GC741@basil.fritz.box>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204171333.GS18989@one.firstfloor.org> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD552@orsmsx506.amr.corp.intel.com> <20091204200933.GA741@basil.fritz.box> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD710@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD710@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Of course you would need to have a timeout before reset, and at this point the
> > delay loops are not calibrated yet, so you don't know how to wait.

That was actually wrong, since you're coming back from S3
udelay should work. nm.

> 
> I would expect that early_printk() coupled with tboot's serial output would be sufficient for a case such as this.  If we've done our work correctly, loss of integrity should only occur when the system is attacked across the S3 transition--which should be fairly rare and which should place a premium on prevention of the attacked code from executing.  Esp. on servers, there may not be anyone to see console output anyway.  Does early_printk() and a tboot reset seem like a reasonable approach?

At least classical vga/serial early_printk should be safe, I'm not sure
about the early USB code recently added though, some auditing on that
first would be good.

early_printk defaults to VGA text output, so if you do a reset you would
need a delay first, otherwise noone can see it ever. But one could be
done with udelay()

It'll be also invisible with frame buffer active, which is the common
case for distributions.  So basically in most cases the message would be
invisible.

(not that panic is much better by default in this regard though,
at least not without Jesse's recent frame buffer work ...)

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
