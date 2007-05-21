Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXEUGIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXEUGIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbXEUGIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:08:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbXEUGIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:08:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZR5em//4dQDUNatpYVJwPnniD+pWnbdcFWiPNECWujRzdjoe42Shzs/arhWYEbsFi
	35G+x8cYVvwHeK56oYjmA==
Message-ID: <b040c32a0705202308h7fda56c1r85bac3ce4c172488@mail.gmail.com>
Date: Sun, 20 May 2007 23:08:35 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> Yeah, that's the only one left. I was hoping it wasn't that one, as it
> claimed to have been tested extensively. Guess it wasn't tested with
> udev.
>
> Ken? Ball's in your court. As the patch isn't providing a killer
> feature for 2.6.22, I'd suggest just reverting it for now until the
> issues are ironed out.

The real solution is to have the user space tool to create these
device nodes in advance.

The original loop patch was coded such that when we open a loop device
N, the immediate adjacent device "N + 1" is created.  This will keep
"mount -o loop" happy because it typically does a linear scan to find
a free device.  This might be somewhat hackary, but certainly will be
backward compatible before user space solution is deployed.

However, the code was removed by Al in this commit:

commit 07002e995638b83a6987180f43722a0eb39d4932
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat May 12 16:23:15 2007 -0400

    fix the dynamic allocation and probe in loop.c

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Acked-by: Ken Chen <kenchen@google.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
