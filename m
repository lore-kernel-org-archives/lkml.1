Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbXEPUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbXEPUBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPUBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:01:12 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50798 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEPUBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:01:11 -0400
Subject: Re: 2.6.22-rc1-mm1
From: Richard Purdie <rpurdie@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070516100632.391f5459.akpm@linux-foundation.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <20070516095018.6f0048bc.randy.dunlap@oracle.com>
	 <1179334843.5854.28.camel@localhost.localdomain>
	 <20070516100632.391f5459.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 May 2007 21:00:53 +0100
Message-Id: <1179345653.5854.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 10:06 -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 18:00:43 +0100 Richard Purdie <rpurdie@openedhand.com> wrote:
> 
> > On Wed, 2007-05-16 at 09:50 -0700, Randy Dunlap wrote:
> > > On Tue, 15 May 2007 20:19:14 -0700 Andrew Morton wrote:
> > > 
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> > > 
> > > LZO build fails on allyesconfig:
> > > 
> > > lib/built-in.o: In function `lzo1x_1_compress':
> > > lib/lzo/minilzo.c:724: multiple definition of `lzo1x_1_compress'                           fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1307: first defined here
> > > ld: Warning: size of symbol `lzo1x_1_compress' changed from 1541 in fs/built-in.o to 244 in lib/built-in.o
> > > lib/built-in.o: In function `lzo1x_decompress':                                            lib/lzo/minilzo.c:885: multiple definition of `lzo1x_decompress'
> > > fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1466: first defined here                ld: Warning: size of symbol `lzo1x_decompress' changed from 1047 in fs/built-in.o to 678 in lib/built-in.o
> > > make: *** [.tmp_vmlinux1] Error 1
> > > make: Target `all' not remade because of errors.
> > 
> > Looks like reiser4 contains a copy of minilzo used as some kind of
> > compression plugin. It can be dropped in favour of the version in
> > lib/lzo/, they'll be compatible.
> > 
> > Andrew: Do you want a patch to remove it from reiser4?
> > 
> 
> yes please.

Sent.

I also noticed that reiser4 is using lzo1x_decompress(), not
lzo1x_decompress_safe(). The unsafe version is open to buffer overflows
through malicious data since it performs no validation of where it
writes output to. I'm not sure whether thats acceptable in filesystem
code, I'd suspect not?

Fixing it is a case of s/lzo1x_decompress(/lzo1x_decompress_safe(/ in 
fs/reiser4/plugin/compress/compress.c...

Richard


