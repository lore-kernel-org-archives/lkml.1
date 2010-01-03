Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227Ab0ACA6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0ACA6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 19:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994Ab0ACA57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 19:57:59 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:39768 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000Ab0ACA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 19:57:59 -0500
Message-ID: <4B3FEB1B.7040106@lougher.demon.co.uk>
Date: Sun, 03 Jan 2010 00:55:55 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] libs: force lzma_wrapper to be retained
References: <20100101120737.94d4acc4.sfr@canb.auug.org.au> <20100101183344.398f2538.randy.dunlap@oracle.com>
In-Reply-To: <20100101183344.398f2538.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_SQUASHFS=m and CONFIG_DECOMPRESS_LZMA=m, decompress_lzma
> is built but then discarded from the library because no built-in code
> uses it, so change it from a lib- to an obj- to force it to be kept
> in the library.
> 
> ERROR: "unlzma" [fs/squashfs/squashfs.ko] undefined!
> 

Thanks for fixing this, I should have spotted it in my various
config tests but didn't.  I could add this to my squashfs-next patches
to stop the linux-next tree breakage, however, should it go into
Michal's kbuild -next tree instead?

This patch raises a small additional issue, why is DECOMPRESS_LZMA
(and DECOMPRESS_GZIP/DECOMPRESS_BZIP2) and defined as tristate?
None of the above compressors can be built as modules.

Regards

Phillip
