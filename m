Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbXCXVfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbXCXVfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXCXVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:35:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60327
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbXCXVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:34:56 -0400
Date: Sat, 24 Mar 2007 12:36:13 -0700 (PDT)
Message-Id: <20070324.123613.130229822.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-03-24-00-14.tar.gz uploaded
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070324101653.602d9a79.akpm@linux-foundation.org>
References: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
	<6bffcb0e0703241018h6761df0oe3a7dea0bab8be78@mail.gmail.com>
	<20070324101653.602d9a79.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 24 Mar 2007 10:16:53 -0800

> On Sat, 24 Mar 2007 18:18:42 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > On 24/03/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > > The mm snapshot broken-out-2007-03-24-00-14.tar.gz has been uploaded to
> > >
> > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-24-00-14.tar.gz
> > >
> > 
> > My network doesn't work
> > "RTNETLINK answers: Invalid argument"
> > 
> > git-net* patches?
> > 
> 
> There's a huge collision between git-net and git-wireless which I haven't
> started to look at yet.  I suggest you forget about that particular
> snapshot.

We fixed that bug about a day after you likely took a snapshot
of the net-2.6.22 tree.

Here is the fix:

commit 65f96c1f4b549a3c3c19cebf9f0795c0d8fb35f0
Author: Thomas Graf <tgraf@suug.ch>
Date:   Thu Mar 22 21:41:06 2007 -0700

    [RTNL]: Properly return rntl message handler
    
    Signed-off-by: Thomas Graf <tgraf@suug.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 35ce9f7..3a295e3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -122,10 +122,10 @@ static rtnl_doit_func rtnl_get_doit(int protocol, int msgindex)
 	struct rtnl_link *tab;
 
 	tab = rtnl_msg_handlers[protocol];
-	if (tab == NULL || tab->doit == NULL)
+	if (tab == NULL || tab[msgindex].doit == NULL)
 		tab = rtnl_msg_handlers[PF_UNSPEC];
 
-	return tab ? tab->doit : NULL;
+	return tab ? tab[msgindex].doit : NULL;
 }
 
 static rtnl_dumpit_func rtnl_get_dumpit(int protocol, int msgindex)
@@ -133,10 +133,10 @@ static rtnl_dumpit_func rtnl_get_dumpit(int protocol, int msgindex)
 	struct rtnl_link *tab;
 
 	tab = rtnl_msg_handlers[protocol];
-	if (tab == NULL || tab->dumpit == NULL)
+	if (tab == NULL || tab[msgindex].dumpit == NULL)
 		tab = rtnl_msg_handlers[PF_UNSPEC];
 
-	return tab ? tab->dumpit : NULL;
+	return tab ? tab[msgindex].dumpit : NULL;
 }
 
 /**
