Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZGAQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZGAQ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZGAQ1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:27:06 -0400
Received: from carryall.technologeek.org ([62.4.18.94]:42361 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbZGAQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:27:06 -0400
From: Julien BLACHE <jb@jblache.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <gregkh@suse.de>,
       felixb@sgi.com, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 000/108] 2.6.30-stable review
References: <20090701002838.GA7100@kroah.com>
	<87tz1wd4vi.fsf@sonic.technologeek.org>
	<4A4B7A77.8010208@s5r6.in-berlin.de>
	<87hbxwcswp.fsf@sonic.technologeek.org>
	<43e72e890907010922t7bd80108xa3caaf4decfd87a6@mail.gmail.com>
Date: Wed, 01 Jul 2009 18:27:07 +0200
In-Reply-To: <43e72e890907010922t7bd80108xa3caaf4decfd87a6@mail.gmail.com>
	(Luis R. Rodriguez's message of "Wed, 1 Jul 2009 09:22:23 -0700")
Message-ID: <87d48kcqsk.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

Hi,

>> Actually I was under the impression that the proper request had been
>> made for inclusion into -stable, but it looks like it's not been done
>> after all.
>>
>> So, here goes.
>
> Better inline.

Crap, I got tricked by the inline thing again. Sorry, properly inlined
this time.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169



From: Felix Blyakher <felixb@sgi.com>
Date: Thu, 11 Jun 2009 22:07:28 +0000 (-0500)
Subject: xfs: fix freeing memory in xfs_getbmap()
X-Git-Url: http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs%2Fxfs.git;a=commitdiff_plain;h=7747a0b0af5976ba3828796b4f7a7adc3bb76dbd

xfs: fix freeing memory in xfs_getbmap()

Regression from commit 28e211700a81b0a934b6c7a4b8e7dda843634d2f.
Need to free temporary buffer allocated in xfs_getbmap().

Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Hedi Berriche <hedi@sgi.com>
Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4b0f6ef..7928b99 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6086,6 +6086,7 @@ xfs_getbmap(
 			break;
 	}
 
+	kmem_free(out);
 	return error;
 }
 
