Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXLMAgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXLMAgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXLMAgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:36:47 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:46162 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbXLMAgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:36:46 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 19:36:46 EST
Message-ID: <4760707B.2040007@gmail.com>
Date: Thu, 13 Dec 2007 02:36:27 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: Re: [RFC] [PATCH -mm] reiser4: replace uid==0 check with capability
References: <20071212210107.GB24708@sergelap.austin.ibm.com>
In-Reply-To: <20071212210107.GB24708@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:

>>From c257cb67ce00c8769730cfa92379a53009d99b28 Mon Sep 17 00:00:00 2001
>From: serue@us.ibm.com <serue@us.ibm.com>
>Date: Wed, 5 Dec 2007 14:02:45 -0800
>Subject: [RFC] [PATCH -mm] reiser4: replace uid==0 check with capability
>
>Reiser4 gives root some reserved blocks.  Replace the uid==0 check, which
>is not safe in the face of user namespaces, with a CAP_SYS_RESOURCE check,
>which seems appropriate.
>
>  
>

Agreed. Thanks,
Edward.

>The per-uid and per-guid reservations appear unimplemented so I'm ignoring
>them.
>
>Signed-off-by: Serge Hallyn <serue@us.ibm.com>
>---
> fs/reiser4/super.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/reiser4/super.c b/fs/reiser4/super.c
>index bc4113e..50e3d09 100644
>--- a/fs/reiser4/super.c
>+++ b/fs/reiser4/super.c
>@@ -144,7 +144,7 @@ long reiser4_reserved_blocks(const struct super_block *super	/* super block
> 		reserved += reserved_for_gid(super, gid);
> 	if (REISER4_SUPPORT_UID_SPACE_RESERVATION)
> 		reserved += reserved_for_uid(super, uid);
>-	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && (uid == 0))
>+	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && capable(CAP_SYS_RESOURCE))
> 		reserved += reserved_for_root(super);
> 	return reserved;
> }
>  
>

