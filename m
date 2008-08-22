Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYHVRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYHVRj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYHVRjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:39:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2257 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYHVRjS (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ksXhmdVewAtGF4mpo5Nabi1itaptrCcgxp30TIXxqBzLBhdUa/NObLhiHzDuXXOF8/
         ynU+k3KD5CHaaIVxTzrQB5e2Bv+DMqJrrKMYbHDO4jzdLOsNDaqm58pGNE2ScKa1T0vz
         SOCP/zfEOnCFEqDvuyWahQJY6/eEcHmaVD+7A=
Message-ID: <6934efce0808221039o3ea57e35ka24a617621e2646e@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:39:18 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>
Subject: Re: [PATCH 07/10] AXFS: axfs_bdev.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080822125440.GA1396@mx.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD010B.6030209@gmail.com> <20080822125440.GA1396@mx.loc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mismatch between documentation and implementation WRT the function name ;)
oops.

>>+{
>>+      struct axfs_super *sbi = AXFS_SB(sb);
>>+      u64 boffset = AXFS_FSOFFSET_2_DEVOFFSET(sbi, fsoffset);
>>+      u64 blocks;
>>+      u64 blksize = sb->s_blocksize;
>>+      unsigned long dst;
>>+      unsigned long src;
>>+      sector_t block;
>>+      size_t bytes;
>>+      struct buffer_head *bh;
>>+      u64 copied = 0;
>>+
>>+      if (len == 0)
>>+              return 0;
>>+
>>+      blocks = len / blksize;
>>+      if ((len % blksize) > 0)
>>+              blocks += 1;
>>+
>>+      while (copied < len) {
>>+              /* Explicit casting for ARM linker errors. */
>
> did it try to emit some external div()? Is this still needed?

exactly.  I haven't heard otherwise, it was a Freescale ARM11 build
that had the issue... I don't have the set up.
