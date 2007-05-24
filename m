Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXEXUO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXEXUO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXEXUOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:14:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXEXUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a4f9pvCb/6JvpxgWtjN/AU6hrjeyx26rDSs7POH1n0xEnfozSfVN/lHQCVZsjHMYBlvgqPemnLGqsqAoXr2KME4RfYIbdwuW/5MPBeVJvHJJ6XqIvdmls03/6lpc32VqExztIp714TqQ83C3Yn8M0eIO9fGinBPIZzfZUubWLko=
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
	-stablereview)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 May 2007 22:14:08 +0200
Message-Id: <1180037649.15241.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 08:28 -0700, Linus Torvalds wrote:
> 

> Can you compile those two modules with PCMCIA_DEBUG=4?
> 
> Something like
> 
> 	make EXTRA_CFLAGS=-DPCMCIA_DEBUG=4
> 
> should do it. You might also enable CONFIG_PCMCIA_DEBUG while you're at 
> it. And then the extra debugging output hopefully will narrow down where 
> things go south.

Compiling now. I had lost a lot of time because at first try it stopped
in ntfs:

  CC [M]  fs/ntfs/super.o
fs/ntfs/super.c: In function ‘init_ntfs_fs’:
fs/ntfs/super.c:3152: error: expected ‘)’ before ‘NTFS_VERSION’
fs/ntfs/super.c: At top level:
fs/ntfs/super.c:3262: error: expected ‘,’ or ‘;’ before ‘NTFS_VERSION’
make[2]: *** [fs/ntfs/super.o] Error 1
make[1]: *** [fs/ntfs] Error 2
make: *** [fs] Error 2
  
I suppose because NTFS_VERSION were defined as EXTRA_CFLAGS too in the Makefile, 
and I corrected it adding a fake #define NTFS_VERSION in super.c. Then I
got to a meeting, and coming back:
  
  CC [M]  fs/xfs/quota/xfs_dquot.o
fs/xfs/quota/xfs_dquot.c:18:17: error: xfs.h: No such file or directory
fs/xfs/quota/xfs_dquot.c:19:20: error: xfs_fs.h: No such file or directory
fs/xfs/quota/xfs_dquot.c:20:21: error: xfs_bit.h: No such file or directory
fs/xfs/quota/xfs_dquot.c:21:21: error: xfs_log.h: No such file or directory

So I gave up and lost^Wused a couple of hours trimming  down .config, and 
now it's compiling.

Romano


