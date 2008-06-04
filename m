Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbYFDFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbYFDFzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYFDFz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:55:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39294 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbYFDFzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:55:24 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 04 Jun 2008 06:41:55 +0200)
Subject: Re: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
References: <4845C4D2.8050408@gmail.com> <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
Message-Id: <E1K3lxO-0007t2-2d@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 07:54:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At which point the "if (f)" and the "else" branches become equivalent
> (the nameidata isn't interesting in the other case either).  So that
> could be written as:
> 
> 		if (!is_owner_or_cap(inode)) {
> 			error = permission(inode, MAY_WRITE, NULL);
> 			if (error)
> 				goto mnt_drop_write_and_out;
> 		}

And also the IS_IMMUTABLE() check can be removed, since it's checked
by permission(MAY_WRITE) anyway.

Miklos
