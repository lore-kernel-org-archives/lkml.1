Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYHNOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYHNOz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYHNOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:55:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:55482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYHNOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:55:18 -0400
Date: Thu, 14 Aug 2008 07:53:48 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080814145348.GA25422@kroah.com>
References: <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com> <20080811173616.GC6103@redhat.com> <20080811223309.GD9810@kroah.com> <20080812194817.GD6056@redhat.com> <20080812200908.GA444@kroah.com> <20080812204619.GE6056@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812204619.GE6056@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 04:46:19PM -0400, Jason Baron wrote:
> On Tue, Aug 12, 2008 at 01:09:08PM -0700, Greg KH wrote:
> > So close, can I have a good changelog comment with the patch so people
> > know what it is when they look in the logs?
> > 
> > Care to resend it with that?
> > 
> 
> Base infrastructure to enable per-module debug messages.

<snip>

Ok, I got the build problem with the usb-gadget drivers all worked out
now, and added this to my driver-core tree.

Very nice stuff, again, thanks for doing this.  I'll work to clean up
the USB drivers to all rely on this and not their separate
CONFIG_USB_DEBUG option.

Also, would it make sense to add a patch like the one below to this
code?  It might be nice to know when each module's debugging value is
manually changed by the user for the log files.

If you like it, I can merge it in the main patch.

thanks,

greg k-h

---
 lib/dynamic_printk.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -288,6 +288,9 @@ static ssize_t pr_debug_write(struct fil
 					num_enabled++;
 					dynamic_enabled = DYNAMIC_ENABLED_SOME;
 					err = 0;
+					printk(KERN_DEBUG
+					       "debugging enabled for module %s",
+					       elem->name);
 				} else if (!value && (elem->enable == 1)) {
 					elem->enable = 0;
 					num_enabled--;
@@ -304,6 +307,9 @@ static ssize_t pr_debug_write(struct fil
 						dynamic_enabled =
 							DYNAMIC_ENABLED_NONE;
 					err = 0;
+					printk(KERN_DEBUG
+					       "debugging disabled for module "
+					       "%s", elem->name);
 				}
 			}
 		}
