Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZGON7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZGON7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZGON7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:59:16 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42578 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZGON7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=mO0NTY8ORNeV5kRiiDWnNZbrFzrdpC4XmnN/CNKfiEv48ljsig4JqUab9gQjVUOjr+
         511QtbwyDXbj9B2WUdvL7EOF/Fot6HobvUQ+Mqxthd4mQsdgtoqgJvHC9DSD4Q4qK5KE
         AD6/uk1t7x3tejd/eEBnFz2NtKZFjdd8tVt/I=
Message-ID: <4A5DE10E.7010005@gmail.com>
Date: Wed, 15 Jul 2009 16:00:46 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bio: sizeof pointer instead of size of the pointed-to type?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not take the size of a pointer to determine the size of the pointed-to type

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This is not yet tested. Is it correct?

diff --git a/fs/bio.c b/fs/bio.c
index 7673800..e65c35d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -96,7 +96,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 	if (bio_slab_nr == bio_slab_max && entry == -1) {
 		bio_slab_max <<= 1;
 		bio_slabs = krealloc(bio_slabs,
-				     bio_slab_max * sizeof(struct bio_slab),
+				     bio_slab_max * sizeof(struct bio_slab *),
 				     GFP_KERNEL);
 		if (!bio_slabs)
 			goto out_unlock;
