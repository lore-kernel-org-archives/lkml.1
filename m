Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYCXE4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYCXE4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 00:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYCXE4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 00:56:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53233
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbYCXE4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 00:56:42 -0400
Date: Sun, 23 Mar 2008 21:56:41 -0700 (PDT)
Message-Id: <20080323.215641.192753003.davem@davemloft.net>
To: samuel.thibault@ens-lyon.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080308022321.GC5853@implementation>
References: <20080308022321.GC5853@implementation>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Sat, 8 Mar 2008 02:23:21 +0000

> Accept and getpeername are supposed to return the amount of bytes
> written in the returned address.  However, on unnamed sockets, only
> sizeof(short) is returned, while a 0 is put in the sun_path member.
> This patch adds 1 for that additional byte.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

This change isn't correct.  It's the fact that the
length returned is sizeof(short) that tells the caller
that the unix socket is unnamed.

We zero out the sun_path[0] member just to be polite
and tidy.

You would break applications if you changed this, so
marking this patch as "trivial" is extremely premature.
