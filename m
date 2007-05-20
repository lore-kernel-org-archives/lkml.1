Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXETLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXETLnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXETLnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:43:13 -0400
Received: from mail.syneticon.net ([213.239.212.131]:49318 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbXETLnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:43:12 -0400
Message-ID: <46503441.9050409@wpkg.org>
Date: Sun, 20 May 2007 13:42:57 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] LZO1X de/compression support
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Rugolsky Jr. wrote:

>> I'm certainly missing something but what are the advantages of this
>> code (over current gzip etc.), and what will be using it?
> 
> Richard's patchset added it to the crypto library and wired it into
> the JFFS2 file system.  We recently started using LZO in a userland UDP
> proxy to do stateless per-packet payload compression over a WAN link.
> With ~1000 octet packets, our particular data stream sees 60% compression
> with zlib, and 50% compression with (mini-)LZO, but LZO runs at ~5.6x
> the speed of zlib.  IIRC, that translates into > 700Mbps on the input
> side on a 2GHZ Opteron, without any further tuning.
> 
> Once LZO is in the kernel, I'd like to see it wired into IPComp.
> Unfortunately, last I checked only the "deflate" algorithm had an
> assigned compression parameter index (CPI), so one will have to use a
> private index until an official one is assigned.

I also though of using LZO compression for some of the diskless nodes
which use iSCSI over 100 Mbit or slower.


Certainly, a fast de/compression algorithm in the kernel could bring
some new, innovative uses:

- there are talks about compressed filesystems (jffs2, reiser4, LogFS) -
why no one thought about a compressed tmpfs (should be way easier than a
compressed on-disk filesystem, as we don't have to care about data
recovery in event of a failure)?

- using compression for networking (like Bill mentioned)

- compressed caching

- compressed suspend-to-disk images (should suspend/restore faster this way)


-- 
Tomasz Chmielewski
http://wpkg.org





