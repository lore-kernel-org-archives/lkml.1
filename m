Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZBAPlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZBAPlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZBAPli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:41:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZBAPlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:41:37 -0500
Message-ID: <4985C1B0.8060905@sandeen.net>
Date: Sun, 01 Feb 2009 09:37:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
       mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk,
       Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
 for compatibility with legacy xfs ioctls
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>	<20090130171423.f99c88d0.akpm@linux-foundation.org>	<200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com>	<Pine.LNX.4.64.0902011104320.20875@anakin>	<49857BEB.30404@panasas.com>	<Pine.LNX.4.64.0902011151180.20875@anakin> <4985966D.8040402@panasas.com>
In-Reply-To: <4985966D.8040402@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:

...

> I don't understand
> 
> if you have a structure like
> struct foo {
> 	u32 one;
> 	u32 two;
> };
> vs
> struct foo_packed {
> 	u32 one;
> 	u32 two;
> } __packed;
> 
> Just adding an __attribute__((packed)) to it clearly does not change
> the layout of the structure. Are you saying the __attribute__((packed))
> is an hint to the compiler that foo_packed might be used unaligned. This
> is just brain-dead, because I can use an unaligned pointer to foo just as
> I can to foo_packed. Otherwise there is no difference what-so-ever between
> the two. I have to see it to believe. It is totally the wrong hint in the
> wrong place taking away valuable meaning of saying "please don't use padding
> holes in this structure"
> 
> Sorry for been so slow, I just don't get it.
> Boaz

While I'm no gcc guru, I can confirm that gratuitous use of the packed
attribute is suboptimal; adding "packed" to every ondisk structure made
obdump -d xfs.ko | wc -l explode by about 15,000 lines on ia64.

-Eric
