Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbXFRJr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbXFRJr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbXFRJru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:47:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbXFRJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:47:49 -0400
Date: Mon, 18 Jun 2007 02:48:07 -0700 (PDT)
Message-Id: <20070618.024807.45712241.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu>
References: <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
	<20070618.023520.102546505.davem@davemloft.net>
	<E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 11:44:07 +0200

> > Secondarily, this bug has been around for years and nobody noticed.
> > The world will not explode if this bug takes a few more days or
> > even a week to work out.  Let's do it right instead of ramming
> > arbitrary turds into the kernel.
> 
> Fine, but just wishing a bug to get fixed won't accomplish anything.
> I've spent a fair amount of time debugging this thing, and I'm out of
> ideas.  Really.  So unless somebody steps up to look at this, it won't
> _ever_ get fixed.

Somone just needs to find a way to only lock the socket as it is
being operated upon.

The race you are dealing with is rather simple, the queue check
and the state check need to be done atomically.  The only chore
is to find a way to make that happen in the context of what the
garbage allocator is trying to do.

I'm not even convinced that your most recent attempt is deadlock free.
Locking multiple objects the same way all at once like that is
something that needs to be seriously audited.
