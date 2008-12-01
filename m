Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYLAEhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYLAEhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLAEhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:37:37 -0500
Received: from ozlabs.org ([203.10.76.45]:53269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYLAEhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:37:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: mmotm 2008-11-29-01-53 uploaded
Date: Mon, 1 Dec 2008 15:07:33 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
References: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org> <20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011507.33677.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008 12:40:40 KAMEZAWA Hiroyuki wrote:
> On Sat, 29 Nov 2008 01:59:56 -0800
>
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-11-29-01-53 has been uploaded to
> >
> >    http://userweb.kernel.org/~akpm/mmotm/
> >
> > It contains the following patches against 2.6.28-rc6:
>
> Hi, in recent changes of linux-next.patch

Yep, it was mine.  Latest linux-next should have the fix (sfr berated me for
this bug earlier), which is below:

core_param: call these really, really early - fix

USB sets prefix to "", so there's no dot.  We should really be using
core_param for this.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/params.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -634,7 +634,9 @@ static void __init param_sysfs_builtin(v
 			continue;
 
 		dot = strchr(kp->name, '.');
-		BUG_ON(!dot);
+		/* FIXME: USB code sets prefix to "".  Should use core_param */
+		if (!dot)
+			continue;
 		name_len = dot - kp->name + 1;
 		strlcpy(modname, kp->name, name_len);
 		kernel_add_sysfs_param(modname, kp, name_len);

