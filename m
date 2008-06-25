Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYFYMmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYFYMmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbYFYMlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:41:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34470 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbYFYMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:41:34 -0400
Message-Id: <20080625124038.103406301@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 25 Jun 2008 14:40:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: [patch 0/2] splice: fix nfs export of fuse filesystems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it wasn't that hard to fix just this issue.  I tested the
following two patches, and verified that splice-in and splice-out now
always return full counts, even if pages are invalidated during the
splicing.

The ClearPageUptodate() thing in 1/2 needs a bit of careful attention
from VM hackers (Hugh and Nick added to CC).

I still see small issues with generic_file_splice_read() (more in a
separate email) and I don't quite see how this async thing is going to
work out, but that's another story.

Thanks,
Miklos
--
