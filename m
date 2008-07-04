Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYGDClf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYGDClf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbYGDClM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:41:12 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48059 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756682AbYGDClK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:41:10 -0400
Date: Fri, 4 Jul 2008 11:41:09 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, xen-ia64-devel@lists.xensource.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] xen: compilation fix for ia64 support.
Message-ID: <20080704024109.GE17895%yamahata@valinux.co.jp>
References: <20080703070952.GB15683%yamahata@valinux.co.jp> <486D49C7.5070702@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486D49C7.5070702@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:51:03PM -0700, Jeremy Fitzhardinge wrote:
> Isaku Yamahata wrote:
> >don't include asm/pvclock-abi.h directly, but asm/xen/pvclock-abi.h
> >At this moment linux ia64 won't accept asm/pvclock-abi.h because
> >there's no user of it.
> 
> Huh?  Is this a ia64 maintainer policy?  Aren't you about to start using it?

Ah sorry, that was only what I expected. I haven't asked the maintainer yet.
I'm asking now.


> > Instead make it include asm/xen/pvclock-abi.h
> >and create asm-x86/xen/pvclock-abi.h which includes asm-x86/pvclock-abi.h.
> >  
> 
> I'm not very keen on crufting up asm-x86/xen/ for the ia64 code.  
> Couldn't you have an asm-ia64/xen/pvclock-abi.h which includes 
> <asm-x86/pvclock-abi.h>?

I'm file with that. In fact I don't have strong opinion here
as long as the linux ia64 maintainer, Tony, is fine.

Tony, what do you think about the following patch?
- path
  asm-ia64/pvclock-abi.h versus asm-ia64/xen/pvclock-abi.h
- including asm-x86/pvclock-abi.h

>From fa958c98713f193eeab2cbe9bab1676059b850a3 Mon Sep 17 00:00:00 2001
From: Isaku Yamahata <yamahata@valinux.co.jp>
Date: Fri, 4 Jul 2008 11:29:33 +0900
Subject: [PATCH] ia64/xen: add a neccessary header file to copmle include/xen/interface/xen.h

Create include/asm-ia64/pvclock-abi.h to compile which includes
include/asm-x86/pvclock-abi.h because ia64/xen uses same struture.
Hopefully include/asm-x86/pvclock-abi.h would be moved to somewhere
more generic.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 include/asm-ia64/pvclock-abi.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-ia64/pvclock-abi.h

diff --git a/include/asm-ia64/pvclock-abi.h b/include/asm-ia64/pvclock-abi.h
new file mode 100644
index 0000000..1c34d11
--- /dev/null
+++ b/include/asm-ia64/pvclock-abi.h
@@ -0,0 +1,5 @@
+/*
+ * use same streucute to x86's
+ * Hopefully asm-x86/pvclock-abi.h would be moved to somewhere more generic.
+ */
+#include <asm-x86/pvclock-abi.h>
-- 
1.5.3


-- 
yamahata
