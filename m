Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYLJXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYLJXnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYLJXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:43:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:42154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYLJXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:43:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,749,1220252400"; 
   d="scan'208";a="88823619"
Date: Thu, 11 Dec 2008 07:43:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081210234317.GA5904@localhost>
References: <20081210073347.GA18737@localhost> <1228904326.19553.127.camel@violet.holtmann.net> <20081210144058.GA11842@localhost> <20081210152323.GB446@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210152323.GB446@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 05:23:23PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Dec 10, 2008 at 10:40:58PM +0800, Wu Fengguang wrote:
> > On Wed, Dec 10, 2008 at 12:18:46PM +0200, Marcel Holtmann wrote:
> > > Hi,
> > > 
> > > > Append '\n' to two printk messages.
> > > 
> > > I already sent a patch for that and Greg picked it up.
> > 
> > No I didn't find it in the usb-2.6 tree:
> > 
> > git pull git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> > >From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
> >  * branch            HEAD       -> FETCH_HEAD
> > Already up-to-date.
> 
> That's not the "usb" tree, if you read the description, it should be
> clear.

Yup, it reads "junk tree, please ignore". When I first found it in
git.kernel.org, I chose to trust the name 'usb-2.6' instead of its
description...

> My tree is in quilt, please see the MAINTAINERS file for details.

Got it. Below is the updated patch based on Marcel's one.

Thanks,
Fengguang
---
dynamic_printk: reduce one level of indentation

Cleanup pr_debug_write() to reduce one level of indentation.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 lib/dynamic_printk.c |   58 ++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

--- mm.orig/lib/dynamic_printk.c
+++ mm/lib/dynamic_printk.c
@@ -277,40 +277,34 @@ static ssize_t pr_debug_write(struct fil
 				dynamic_enabled = DYNAMIC_ENABLED_NONE;
 			}
 			err = 0;
-		} else {
-			if (elem) {
-				if (value && (elem->enable == 0)) {
-					dynamic_printk_enabled |=
-							(1LL << elem->hash1);
-					dynamic_printk_enabled2 |=
-							(1LL << elem->hash2);
-					elem->enable = 1;
-					num_enabled++;
-					dynamic_enabled = DYNAMIC_ENABLED_SOME;
-					err = 0;
-					printk(KERN_DEBUG
-					       "debugging enabled for module %s\n",
-					       elem->name);
-				} else if (!value && (elem->enable == 1)) {
-					elem->enable = 0;
-					num_enabled--;
-					if (disabled_hash(elem->hash1, true))
-						dynamic_printk_enabled &=
+		} else if (elem) {
+			if (value && (elem->enable == 0)) {
+				dynamic_printk_enabled |= (1LL << elem->hash1);
+				dynamic_printk_enabled2 |= (1LL << elem->hash2);
+				elem->enable = 1;
+				num_enabled++;
+				dynamic_enabled = DYNAMIC_ENABLED_SOME;
+				err = 0;
+				printk(KERN_DEBUG
+					"debugging enabled for module %s\n",
+					elem->name);
+			} else if (!value && (elem->enable == 1)) {
+				elem->enable = 0;
+				num_enabled--;
+				if (disabled_hash(elem->hash1, true))
+					dynamic_printk_enabled &=
 							~(1LL << elem->hash1);
-					if (disabled_hash(elem->hash2, false))
-						dynamic_printk_enabled2 &=
+				if (disabled_hash(elem->hash2, false))
+					dynamic_printk_enabled2 &=
 							~(1LL << elem->hash2);
-					if (num_enabled)
-						dynamic_enabled =
-							DYNAMIC_ENABLED_SOME;
-					else
-						dynamic_enabled =
-							DYNAMIC_ENABLED_NONE;
-					err = 0;
-					printk(KERN_DEBUG
-					       "debugging disabled for module "
-					       "%s\n", elem->name);
-				}
+				if (num_enabled)
+					dynamic_enabled = DYNAMIC_ENABLED_SOME;
+				else
+					dynamic_enabled = DYNAMIC_ENABLED_NONE;
+				err = 0;
+				printk(KERN_DEBUG
+					"debugging disabled for module %s\n",
+					elem->name);
 			}
 		}
 	}
