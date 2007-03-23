Return-Path: <linux-kernel-owner+w=401wt.eu-S2992545AbXCWTvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992545AbXCWTvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992546AbXCWTvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:51:05 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20762 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992545AbXCWTvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:51:04 -0400
Message-ID: <46042FA2.20303@tls.msk.ru>
Date: Fri, 23 Mar 2007 22:50:58 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Jiri Kosina <jikos@jikos.cz>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
References: <4603DE86.1090009@slax.org>	<20070323151956.1ac6a47b.dada1@cosmosbay.com>	<Pine.LNX.4.64.0703231522200.5030@twin.jikos.cz> <20070323155115.89f86b3b.dada1@cosmosbay.com>
In-Reply-To: <20070323155115.89f86b3b.dada1@cosmosbay.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
[]
> 
> MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-16384)");

Speaking of which, I wonder...  Here, and in many other places.

If some variable is marked as MODULE_PARAM (or whatever it is called
nowadays), used in module init routine, AND subsequently used for various
bound checks and loops...

Consider this:

  MODULE_PARAM(n);
  foo_init() {
    mem = kmalloc(n * sizeof(void*));
    ..
  }
  foo_func() {
    for (i = 0; i < n; ++i)
      do_something_with_mem(mem[i])
  }

and so on.  Together with:

  # modprobe foo n=10
  # echo 20 > /sys/module/foo/parameters/n

After that, we have 10 entries in mem[], and
n is equal to 20, so the for-loop above will be
up to i=19.  Which will reference unallocated
memory....

Amd I dreaming?

Thanks.

/mjt
