Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbXGJHwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbXGJHwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXGJHwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:52:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:21245 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXGJHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:52:14 -0400
Date: Tue, 10 Jul 2007 09:52:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Morris <jmorris@namei.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] security: Protection for exploiting null dereference
 using mmap
In-Reply-To: <Line.LNX.4.64.0707082259060.12256@d.namei>
Message-ID: <Pine.LNX.4.64.0707100951140.11053@fbirervta.pbzchgretzou.qr>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
 <Line.LNX.4.64.0707082259060.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 8 2007 22:59, James Morris wrote:
>@@ -420,8 +420,12 @@ static int dummy_file_ioctl (struct file *file, unsigned int command,
> 
> static int dummy_file_mmap (struct file *file, unsigned long reqprot,
> 			    unsigned long prot,
>-			    unsigned long flags)
>+			    unsigned long flags,
>+			    unsigned long addr,
>+			    unsigned long addr_only)
> {
>+	if (addr < mmap_min_addr)
>+		return -EACCES;
> 	return 0;
> }
> 

Not -EPERM?


	Jan
-- 
