Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXDOKxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXDOKxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXDOKxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:53:13 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34095 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXDOKxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:53:12 -0400
Subject: Re: [PATCH 7/17] jffs2: convert jffs2_gc_fetch_page to
	read_cache_page
From: David Woodhouse <dwmw2@infradead.org>
To: Nate Diller <nate.diller@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
In-Reply-To: <20070412024938.27380.13619.patchbomb.py@localhost>
References: <20070412024938.27380.13619.patchbomb.py@localhost>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 11:52:47 +0100
Message-Id: <1176634367.7929.63.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 19:49 -0700, Nate Diller wrote:
> Replace jffs2_gc_fetch_page() and jffs2_gc_release_page() using the
> read_cache_page() and put_kmapped_page() calls, and update the call site
> accordingly.  Explicit calls to kmap()/kunmap() make the code more clear.
> 
> Signed-off-by: Nate Diller <nate.diller@gmail.com> 

Please don't remove the jffs2_gc_{fetch,release}_page functions. The
reason they're in a separate file is because that file (fs.c) is built
on Linux only, while the file you're moving the code into (gc.c) is
OS-agnostic; it's used on other sytems (eCos) too.

Rather than forcing eCos and any other systems which have a JFFS2 port
to implement a crappy Linux 'emulation' layer, I try to keep the
Linuxisms localised to certain files which can be completely
reimplemented for a non-Linux port.

-- 
dwmw2

