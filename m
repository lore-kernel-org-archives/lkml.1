Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZDOU3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZDOU3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZDOU3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:29:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbZDOU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:29:42 -0400
Date: Wed, 15 Apr 2009 13:27:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, den@openvz.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded (mtd)
Message-Id: <20090415132746.e45d8fd9.akpm@linux-foundation.org>
In-Reply-To: <49E5FFB8.2020906@oracle.com>
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org>
	<49E5FFB8.2020906@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 08:39:36 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> 
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.30-rc1:
> 
> 
> 
> drivers/mtd/mtdcore.c:51: error: invalid operands to binary *

hrm.  This, I suppose:

From: Andrew Morton <akpm@linux-foundation.org>

--- a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
+++ a/drivers/mtd/mtdcore.c
@@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
  */
 static void mtd_release(struct device *dev)
 {
-	dev_t index = MTD_DEVT(dev_to_mtd(dev));
+	dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
 
 	/* remove /dev/mtdXro node if needed */
 	if (index)
_

