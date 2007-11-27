Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbXK0S06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbXK0S06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXK0S0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:26:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40960 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756120AbXK0S0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:26:50 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Tue, 27 Nov 2007 17:23:46 +0100)
Subject: Re: leak in do_ubd_request
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu>
Message-Id: <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Nov 2007 19:26:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There seems to be no corruption though.  Looking at the code, I can't
> see how the requests could leak...

Didn't look close enough.

Index: linux/arch/um/drivers/ubd_kern.c
===================================================================
--- linux.orig/arch/um/drivers/ubd_kern.c	2007-11-27 19:23:37.000000000 +0100
+++ linux/arch/um/drivers/ubd_kern.c	2007-11-27 19:24:24.000000000 +0100
@@ -1132,6 +1132,7 @@ static void do_ubd_request(struct reques
 					       "errno = %d\n", -n);
 				else if(list_empty(&dev->restart))
 					list_add(&dev->restart, &restart);
+				kfree(io_req);
 				return;
 			}
 
