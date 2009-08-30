Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZH3Ph1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZH3Ph1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZH3Ph1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:37:27 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41789 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710AbZH3Ph0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:37:26 -0400
Date: Sun, 30 Aug 2009 17:37:22 +0200
From: Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc>
To: Celejar <celejar@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Jonas Meurer <jonas@freesources.org>, 541835@bugs.debian.org,
       lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
	dependencies broken
Message-ID: <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
References: <20090825195852.1dfacb6c.celejar@gmail.com> <20090827095516.6817be1e.randy.dunlap@oracle.com> <20090827183500.GC24973@resivo.wgnet.de> <20090827123401.86cd4319.randy.dunlap@oracle.com> <20090828080056.GA3204@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090828080056.GA3204@Chamillionaire.breakpoint.cc>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2009-08-28 10:00:56 [+0200]:

>>> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
>>> even though it has cbc compiled as module as well. but if I recompile
>>> the same kernel sources with Celejars kernel .config, the problem
>>> occurs. thus it must be related to the kernel config in some way.
>It must be the kernel confing since I run .30.stable and it works. I try
>to look at it later.

Your kernel config is fine, the problem is that the initramfs tools do
not copy all of the required modules into the initramfs. The missing
modles are:
- cryptomgr: that one is responsible to load the cbc and aes module and
  bind them to cbc(aes)
- chainiv: that one creates IVs if the "user" does not specify one.
  dm-crypt probably does not use that one but is required due to the way
  crypto works atm.
- krng: provides random numbers and is required by chainiv.

If you add those three to /etc/initramfs/modules than it should work.

Could someone please look at initramfs to figure out why those three
modules are not copied in this reduced setup?

>Sebastian
