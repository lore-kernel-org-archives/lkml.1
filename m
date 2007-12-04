Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXLDI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXLDI0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXLDI0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:26:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:1168 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXLDI0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:26:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WYHQSLrRY3erZkk8UIqNOr8dqqsP+EjFr9iF1WFqEZXMmuBBGwGVMgWKcnInaqfjgyMTrK2dnnlt3ywhfg/zVgnVirne43o+vHtUpxmHtZ9P9NquaRBGPqxubh/Uq6MIYvhd3eTDoFsNPgd1nImsvPsOUMnJkxTZ0I5ZsVIYKdE=
Date: Tue, 4 Dec 2007 16:26:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pktcdvd : add kobject_put when kobject register fails
Message-ID: <20071204082641.GA21746@darkstar.te-china.tietoenator.com>
References: <20071204013144.GA2850@darkstar.lan> <84144f020712032345r6fc1f44cg5f35b23bdb8191be@mail.gmail.com> <a8e1da0712040000n7f94c5bbk3e6526ed395d62d@mail.gmail.com> <Pine.LNX.4.64.0712041004250.20088@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712041004250.20088@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 10:05:24AM +0200, Pekka J Enberg wrote:
> Hi Dave,
> 
> On Tue, 4 Dec 2007, Dave Young wrote:
> > the kobject reference is get in kobject_init, and then kobject_add, if
> > kobject_add fail, it will only cleanup the reference got by itsself.
> > 
> > This topic is discussed in:
> > http://lkml.org/lkml/2007/11/30/9
> 
> Ok, thanks! Please the explanation to the changelog too.
> 

Ok, lets add some explanation.
------------------------------

kobject_put should be called when kobject register functioin fails.

In kobject_register, the kobject reference is get in kobject_init, and then kobject_add. If kobject_add fail, it will only cleanup the reference got by itself.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

---
drivers/block/pktcdvd.c |    4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff -upr linux/drivers/block/pktcdvd.c linux.new/drivers/block/pktcdvd.c
--- linux/drivers/block/pktcdvd.c	2007-11-30 13:13:44.000000000 +0800
+++ linux.new/drivers/block/pktcdvd.c	2007-11-30 13:24:08.000000000 +0800
@@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
 	p->kobj.parent = parent;
 	p->kobj.ktype = ktype;
 	p->pd = pd;
-	if (kobject_register(&p->kobj) != 0)
+	if (kobject_register(&p->kobj) != 0) {
+		kobject_put(&p->kobj);
 		return NULL;
+	}
 	return p;
 }
 /*
