Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYDZB4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYDZB4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 21:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYDZB42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 21:56:28 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:31678 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461AbYDZB41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 21:56:27 -0400
Date: Sat, 26 Apr 2008 02:44:45 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080426014445.GD4792@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Michael Kerrisk <mtk.manpages@googlemail.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20080308022321.GC5853@implementation> <20080323.215641.192753003.davem@davemloft.net> <20080324104330.GF4434@implementation.uk.xensource.com> <87abko734d.fsf@basil.nowhere.org> <20080324121719.GJ4434@implementation.uk.xensource.com> <20080324122700.GK4434@implementation.uk.xensource.com> <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com> <4808D1C5.8050304@gmail.com> <20080424001656.GM4825@implementation> <517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk, le Thu 24 Apr 2008 10:31:15 +0200, a écrit :
> >  > and I see that in net/unix/af_unix.c::unix_getname() there is:
> >  >
> >
> > >                 *uaddr_len = sizeof(short);
> >
> >  I'd say that code should be fixed into using sa_family_t.
> 
> Is there a patch for this?

Here it is



AF_UNIX: make unix_getname use sizeof(sunaddr->sun_family) instead of
sizeof(short).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/net/unix/af_unix.c.orig	2008-04-26 02:41:45.000000000 +0100
+++ linux/net/unix/af_unix.c	2008-04-26 02:42:07.000000000 +0100
@@ -1256,7 +1256,7 @@ static int unix_getname(struct socket *s
 	if (!u->addr) {
 		sunaddr->sun_family = AF_UNIX;
 		sunaddr->sun_path[0] = 0;
-		*uaddr_len = sizeof(short);
+		*uaddr_len = sizeof(sunaddr->sun_family);
 	} else {
 		struct unix_address *addr = u->addr;
 
