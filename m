Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYFKShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYFKShj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYFKShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:37:14 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:2058 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbYFKShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XiWEeaCphSwQ81wTnn30qJ9PHbTxCmRnXq4WNQuOWgs81bQLoDCvKafqpHdaunE1Fr
         nhUTRDdOKJA2ruMTQaYAMzp49vwwAeRjNOX8dhoe3HV4NnEhPTg+YjU1eLq1Z5UidtPs
         7O8k+fSDM8CN3bqTn0tF344AkS8rzV0rcvc8w=
Message-ID: <19f34abd0806111137t4291b9fkb66951aa8f4d456f@mail.gmail.com>
Date: Wed, 11 Jun 2008 20:37:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc5-mm2 - kernel BUG at arch/x86/kernel/setup.c:388!
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1213208897.20475.19.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	 <485011DF.9050606@linux.vnet.ibm.com>
	 <1213208897.20475.19.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5BIcNHl000967

On 6/11/08, Dave Hansen <dave@linux.vnet.ibm.com> wrote:> On Wed, 2008-06-11 at 23:26 +0530, Kamalesh Babulal wrote:>  > Hi Andrew,>  >>  > The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64>  > box with the attached .config file.>>> Just to save everyone the trouble, it looks like this is a new BUG_ON().>  ï»¿>  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/broken-out/fix-x86_64-splat.patch>>  The machine in question is a single-node machine, but with>  CONFIG_NUMA=y.>
Yes. Sorry, I already responded in a separate e-mail (see below), butthat obviously missed all the Ccs. So here it goes again...:
I'm betting
commit a953e4597abd51b74c99e0e3b7074532a60fd031Author: Mike Travis <travis@sgi.com>Date:   Mon May 12 21:21:12 2008 +0200
    sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
will fix this if it's not in -mm2 already.
The BUG() is simply there to prevent silent corruption. Mike alreadyhas a patch that changes it to a WARN(), but it obviously didn't getthrough (either)...

Vegard

On 6/11/08, Vegard Nossum <vegard.nossum@gmail.com> wrote:> On 6/9/08, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:>  > Hi Andrew,>  >>  > The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64>  > box with the attached .config file.>>  (Please apologize for the strange way of replying to this message. It>  seems that LKML gave up delivering to my address, so I'm currently>  reading off lkml.org.)>>  This should already be fixed, but Andrew refused to apply the patch>  before releasing the -mm1 (and -mm2 apparently). I'm attaching the>  patch, can you see if it helps?>>  Thanks.>>>  Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
