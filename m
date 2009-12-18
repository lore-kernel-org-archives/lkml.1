Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZLRPBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZLRPBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZLRPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:01:34 -0500
Received: from khc.piap.pl ([195.187.100.11]:59437 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZLRPBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:01:33 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: dmarkh@cfl.rr.com
Cc: Alain Knaff <alain@knaff.lu>, Mark Hounschell <markh@compro.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, fdutils@fdutils.linux.lu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4AFB3962.2020106@ntlworld.com> <4B292D84.5040306@compro.net>
	<4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net>
	<4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net>
	<4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu>
	<4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu>
	<4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu>
	<4B2A5192.6090602@compro.net> <4B2A6394.3080705@knaff.lu>
	<4B2A98BB.5080406@knaff.lu>
	<alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>
	<4B2AAC87.5000703@knaff.lu>
	<alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>
	<4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>
	<4B2B5F86.1090403@cfl.rr.com>
Date: Fri, 18 Dec 2009 16:01:29 +0100
In-Reply-To: <4B2B5F86.1090403@cfl.rr.com> (Mark Hounschell's message of "Fri,
	18 Dec 2009 05:55:02 -0500")
Message-ID: <m3aaxg1g3a.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell <dmarkh@cfl.rr.com> writes:

> harley:/usr/src/linux-2.6-allstable # git bisect good
> Bisecting: 2443 revisions left to test after this (roughly 11 steps)
> [db563fc2e80534f98c7f9121a6f7dfe41f177a79] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
>
> This one doesn't build:
>
> CC [M]  fs/ext3/super.o
> fs/ext3/super.c: In function ‘ext3_quota_on’:
> fs/ext3/super.c:2839: error: ‘nd’ undeclared (first use in this function)
> fs/ext3/super.c:2839: error: (Each undeclared identifier is reported only once
> fs/ext3/super.c:2839: error: for each function it appears in.)
> make[2]: *** [fs/ext3/super.o] Error 1
> make[1]: *** [fs/ext3] Error 2
> make: *** [fs] Error 2
>
> I haven't yet determined that I can but, if I were to make a modification to the
> tree now to fix this would that screw up the bisect process?

It won't, in such cases.
But you can also git reset --hard another_commit_id (while doing git
bisect) if it fixes this problem (e.g. some next commit).

And you can skip uninteresting parts of the tree when starting git
bisect (though if the cause is in skipped parts, the results will be
meaningless).
-- 
Krzysztof Halasa
