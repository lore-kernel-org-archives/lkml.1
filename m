Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXEWIhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXEWIhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXEWIhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:37:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:52385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbXEWIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PVrkFwGUPL+MOCLWxHhxArRFmjxQ6AVQd3EmFLH55npOq5tC7hbF1Zpt0pMLwX5daOB3vssHTUB4mPqJTCOiIoJE2tV/Xw8NbPgz+XonBqQKgPJxrw2+0ExWu/9xIxNdt2duxhE0v31Mnnz5g1Z7RR5JufQBaJlC7gu739DRiFU=
Message-ID: <a8e1da0705230137r1b2b06cbg7133141d75292e22@mail.gmail.com>
Date: Wed, 23 May 2007 08:37:04 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Steven French" <sfrench@us.ibm.com>
In-Reply-To: <20070522202133.552d1a94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705221750y6f4fb251m53f3efab1f017f4@mail.gmail.com>
	 <20070522192231.6d1a94df.akpm@linux-foundation.org>
	 <a8e1da0705221959i7b01deb7vdd641ef0ed31e63e@mail.gmail.com>
	 <20070522202133.552d1a94.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry for the wrong patch in my last post.

How about save the tsk then call kthread_stop like this:

diff -udr linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
--- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
+++ linux.new/fs/cifs/connect.c 2007-05-23 16:33:54.000000000 +0000
@@ -2069,8 +2069,9 @@
                        srvTcp->tcpStatus = CifsExiting;
                        spin_unlock(&GlobalMid_Lock);
                        if (srvTcp->tsk) {
+                               struct task_struct * tsk = srvTcp->tsk;
                                send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
+                               kthread_stop(tsk);
                        }
                }
                 /* If find_unc succeeded then rc == 0 so we can not end */

Regards
dave
