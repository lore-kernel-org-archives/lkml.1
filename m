Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbXIODGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbXIODGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 23:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbXIODGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 23:06:14 -0400
Received: from ozlabs.org ([203.10.76.45]:39615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXIODGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 23:06:13 -0400
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under
	Virtualization menu
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: jengelh@gmx.de, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <20070914091921.73007c5a.randy.dunlap@oracle.com>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
	 <20070914091921.73007c5a.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 13:05:04 +1000
Message-Id: <1189825504.7262.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 09:19 -0700, Randy Dunlap wrote:
> On Fri, 14 Sep 2007 15:18:44 +1000 Rusty Russell wrote:
> 
> > We turn "Virtualization" into a menu, not a config option, since it's
> > actually only used as a menu.  Then we move lguest under that menu.
> 
> so you want to revert the 2007-july-16 merge that changes
> menu -> menuconfig and makes most of the menus consistent in
> presentation.  I'd rather not, but I don't own it.

Ok, I missed that one.  To me it seems gratuitous to create a config
option simply to control a menu.  However if that is considered the
Right Way, here is the "Just move lguest" variant.

> And Yes, lguest does need to be moved into a better location.

Indeed,
Rusty.
===
Move lguest under the virtualization menu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r c2893801de2a drivers/Kconfig
--- a/drivers/Kconfig	Fri Sep 14 13:24:46 2007 +1000
+++ b/drivers/Kconfig	Fri Sep 14 13:24:49 2007 +1000
@@ -87,6 +87,4 @@ source "drivers/kvm/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
-
-source "drivers/lguest/Kconfig"
 endmenu
diff -r c2893801de2a drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig	Fri Sep 14 13:24:46 2007 +1000
+++ b/drivers/kvm/Kconfig	Fri Sep 14 13:32:22 2007 +1000
@@ -45,4 +36,8 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-endif # VIRTUALIZATION
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the virtualization menu.
+source drivers/lguest/Kconfig
+
+endif # VIRTUALIZATION



