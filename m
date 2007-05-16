Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXEPRBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXEPRBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEPRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:01:10 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:47333 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXEPRBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:01:09 -0400
Subject: Re: 2.6.22-rc1-mm1
From: Richard Purdie <rpurdie@openedhand.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070516095018.6f0048bc.randy.dunlap@oracle.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <20070516095018.6f0048bc.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 18:00:43 +0100
Message-Id: <1179334843.5854.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 09:50 -0700, Randy Dunlap wrote:
> On Tue, 15 May 2007 20:19:14 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> LZO build fails on allyesconfig:
> 
> lib/built-in.o: In function `lzo1x_1_compress':
> lib/lzo/minilzo.c:724: multiple definition of `lzo1x_1_compress'                           fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1307: first defined here
> ld: Warning: size of symbol `lzo1x_1_compress' changed from 1541 in fs/built-in.o to 244 in lib/built-in.o
> lib/built-in.o: In function `lzo1x_decompress':                                            lib/lzo/minilzo.c:885: multiple definition of `lzo1x_decompress'
> fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1466: first defined here                ld: Warning: size of symbol `lzo1x_decompress' changed from 1047 in fs/built-in.o to 678 in lib/built-in.o
> make: *** [.tmp_vmlinux1] Error 1
> make: Target `all' not remade because of errors.

Looks like reiser4 contains a copy of minilzo used as some kind of
compression plugin. It can be dropped in favour of the version in
lib/lzo/, they'll be compatible.

Andrew: Do you want a patch to remove it from reiser4?

Richard

