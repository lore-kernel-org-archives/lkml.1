Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbZEGNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbZEGNi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZEGNiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42561 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZEGNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:08 -0400
Message-Id: <20090507133734.450612199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 07 May 2009 15:37:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: Max Kellermann <max@duempel.org>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] make splice more generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes splice(2) work in more cases:

  - pipe to pipe splicing (zero copy)
  - fallback splice_read which uses readv()
  - fallback splice_write which uses writev()

Just after cleaning up my patches after a vacation I found Max
Kellermann's patch on LKML implementing the first part.  I'll still
post mine, because it's slightly simpler (no ref + unref on the buffer
if not necessary).

One more generalization would be to allow splice to work on two
non-pipes, using an internal intermediate pipe, a-la do_splice_direct().

Comments?

Thanks,
Miklos
--
