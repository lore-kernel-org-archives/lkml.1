Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYHXWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYHXWiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYHXWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:38:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:54914 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYHXWiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:38:10 -0400
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michael Buesch <mb@bu3sch.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <200808241544.12412.mb@bu3sch.de>
References: <200808231610.46473.mb@bu3sch.de>
	 <1219531969.21386.205.camel@pasglop>  <200808241544.12412.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:37:52 +1000
Message-Id: <1219617472.21386.226.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks for your random guess.
> The following workaround seems to fix the crashes on powerpc.
> However, this patch is clearly not what we want for other architectures,
> as they might need -fno-omit-frame-pointer to function properly.

Well, and -pg requires it, even on powerpc, so that won't work for
ftrace. Any chance you can try the workaround that segher proposed
though ?

http://penguinppc.de/~segher/0001-powerpc-Workaround-for-the-ftrace-problem.patch

His workaround only kicks in with CONFIG_FTRACE, that would have to be
fixed of course. Also, I suspect the bits that have -pg in a flag
"remove" section should have also "fno-omit-frame-pointer" in that
remove section too.

> I reproduced the random crashes of kernel and userspace applications
> (without the following patch) on a vanilla 2.6.26 and 2.6.27-rc{1-4}
> kernel. I did _not_ try a 2.6.25 kernel with -fno-omit-frame-pointer, so
> I don't know if it would also crash then.
> 
> I'm currently running more tests on a patched 2.6.27-rc4 kernel, but it
> didn't crash, yet. I already did 5 complete kernel tree compilations. It
> should have crashed by now, but it didn't :)

Thanks !

Ben.


