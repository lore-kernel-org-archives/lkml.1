Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYLLJa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYLLJa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYLLJaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:30:14 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38034 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbYLLJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:30:11 -0500
Date: Fri, 12 Dec 2008 10:29:51 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 4/4] s390: remove s390_root_dev_*()
Message-ID: <20081212102951.01446f22@gondolin>
In-Reply-To: <20081211180025.045b9b4a@gondolin>
References: <1229012203.7968.79.camel@blaa>
	<1229012216-4211-1-git-send-email-markmc@redhat.com>
	<1229012216-4211-2-git-send-email-markmc@redhat.com>
	<1229012216-4211-3-git-send-email-markmc@redhat.com>
	<1229012216-4211-4-git-send-email-markmc@redhat.com>
	<20081211180025.045b9b4a@gondolin>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 18:00:25 +0100,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Thu, 11 Dec 2008 16:16:56 +0000,
> Mark McLoughlin <markmc@redhat.com> wrote:
> 
> > Replace s390_root_dev_register() with root_device_register() etc.
> 
> Nice, one more special case generalized :) I'll give it a run.

You missed one occurrence in iucv (see below); with that patch applied,
everything seems to work as expected, both for root devices created by
built-ins and by modules.

---
 net/iucv/iucv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/net/iucv/iucv.c
+++ linux-2.6/net/iucv/iucv.c
@@ -1682,7 +1682,7 @@ static void __exit iucv_exit(void)
 		kfree(iucv_irq_data[cpu]);
 		iucv_irq_data[cpu] = NULL;
 	}
-	s390_root_dev_unregister(iucv_root);
+	root_device_unregister(iucv_root);
 	bus_unregister(&iucv_bus);
 	unregister_external_interrupt(0x4000, iucv_external_interrupt);
 }
