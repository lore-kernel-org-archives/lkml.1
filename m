Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXGJNK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXGJNK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXGJNKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:10:51 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:45127 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXGJNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:10:51 -0400
Date: Tue, 10 Jul 2007 09:10:48 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] security: Protection for exploiting null dereference
 using mmap
In-Reply-To: <Pine.LNX.4.64.0707100951140.11053@fbirervta.pbzchgretzou.qr>
Message-ID: <Line.LNX.4.64.0707100910270.14361@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
 <Line.LNX.4.64.0707082259060.12256@d.namei>
 <Pine.LNX.4.64.0707100951140.11053@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Jan Engelhardt wrote:

> 
> On Jul 8 2007 22:59, James Morris wrote:
> >@@ -420,8 +420,12 @@ static int dummy_file_ioctl (struct file *file, unsigned int command,
> > 
> > static int dummy_file_mmap (struct file *file, unsigned long reqprot,
> > 			    unsigned long prot,
> >-			    unsigned long flags)
> >+			    unsigned long flags,
> >+			    unsigned long addr,
> >+			    unsigned long addr_only)
> > {
> >+	if (addr < mmap_min_addr)
> >+		return -EACCES;
> > 	return 0;
> > }
> > 
> 
> Not -EPERM?

No, EACCES is what's used.


-- 
James Morris
<jmorris@namei.org>
