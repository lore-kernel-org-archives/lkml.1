Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXE3RsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXE3RsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXE3Rr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:47:59 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbXE3Rr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:47:59 -0400
Date: Wed, 30 May 2007 10:47:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael-Luke Jones <mike.luke.jones@gmail.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [-mm] Move zlib compression library to common directory [TAKE
 TWO]
Message-Id: <20070530104747.41b4995f.akpm@linux-foundation.org>
In-Reply-To: <465C5549.4050101@gmail.com>
References: <465C3973.3090303@gmail.com>
	<465C5549.4050101@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 17:31:05 +0100
Michael-Luke Jones <mike.luke.jones@gmail.com> wrote:

> This patch moves the zlib compression and decompression code
> to a common directory. The zutil.h header, which is not meant
> to be public, is moved from include/linux/ to lib/zlib/.
> 
> In addition, the PRESET_DICT definition from zutil.h, used by
> fs/jffs2/compr_zlib.c is moved to the 'true' public zlib
> header include/linux/zlib.h.
> 
> Conditional compile of only inflate or deflate code is
> preserved by this patch. With a bit of luck, this version
> won't be whitespace-damaged. Grumble.

umm, OK, if you say so.  I'm not sure I understand the point behind
all this, but I'm sure there is one ;)

> diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib/deflate.c
> similarity index 100%
> rename from lib/zlib_deflate/deflate.c
> rename to lib/zlib/deflate.c
> index c3e4a2b..1137780 100644
> diff --git a/lib/zlib_deflate/deflate_syms.c b/lib/zlib/deflate_syms.c
> similarity index 100%
> rename from lib/zlib_deflate/deflate_syms.c
> rename to lib/zlib/deflate_syms.c
> diff --git a/lib/zlib_deflate/deftree.c b/lib/zlib/deftree.c
> similarity index 100%
> rename from lib/zlib_deflate/deftree.c
> rename to lib/zlib/deftree.c
> index ddf3482..d5ce87d 100644
> diff --git a/lib/zlib_deflate/defutil.h b/lib/zlib/defutil.h
> similarity index 100%
> rename from lib/zlib_deflate/defutil.h
> rename to lib/zlib/defutil.h
> diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib/inffast.c
> similarity index 100%
> rename from lib/zlib_inflate/inffast.c
> rename to lib/zlib/inffast.c
> diff --git a/lib/zlib_inflate/inftrees.h b/lib/zlib/inftrees.h
> similarity index 100%
> rename from lib/zlib_inflate/inftrees.h
> rename to lib/zlib/inftrees.h
> diff --git a/lib/zlib_inflate/infutil.h b/lib/zlib/infutil.h
> similarity index 100%
> rename from lib/zlib_inflate/infutil.h
> rename to lib/zlib/infutil.h
> diff --git a/include/linux/zutil.h b/lib/zlib/zutil.h
> similarity index 98%
> rename from include/linux/zutil.h
> rename to lib/zlib/zutil.h
> index 6adfa9a..0467c8c 100644

Lots of git goodies there - I didn't actually receive the patch: the parts
which move files around were communicated via git metadata, not diffs.
Presumably there's a way to tell git to not do that.

But probably it's best that this change be merged via git anyway.  David,
are you interested in handling it?

