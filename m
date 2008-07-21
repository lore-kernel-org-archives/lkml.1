Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYGUPSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYGUPSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYGUPSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:18:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40289
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbYGUPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:18:44 -0400
Date: Mon, 21 Jul 2008 08:18:44 -0700 (PDT)
Message-Id: <20080721.081844.221647067.davem@davemloft.net>
To: roland@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721105431.3BD2015421D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080718.022035.208722773.davem@davemloft.net>
	<20080721105431.3BD2015421D@magilla.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Mon, 21 Jul 2008 03:54:31 -0700 (PDT)

> > The other arch's with compat support will have this same exact issue.
> 
> They don't seem to.

Look at S390 and PowerPC, they do the sign extension cases as well.

PowerPC does it with C level stubs, whereas I believe S390 uses a
similar assembler stub scheme as sparc64.

But you are right, this is probably not an issue, and providing 32-bit
truncated incoming args, and letting the tracer do whatever it likes
for outgoing args, should work just fine.
