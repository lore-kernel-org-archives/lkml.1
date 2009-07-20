Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZGTCUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZGTCUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 22:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZGTCUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 22:20:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64420 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZGTCUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 22:20:13 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix blk_queue_alignment_offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090719223649.GA32719@lst.de>
Date: Sun, 19 Jul 2009 22:19:55 -0400
In-Reply-To: <20090719223649.GA32719@lst.de> (Christoph Hellwig's message of
	"Mon, 20 Jul 2009 00:36:49 +0200")
Message-ID: <yq1ab30jdtg.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A63D44E.0010:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hch" == Christoph Hellwig <hch@lst.de> writes:

hch> We need to mask out bits inside the logical block, not outside of
hch> it, otherwise we'll always get a 0 alignment_offset.

The alignment_offset only makes sense if physical_block_size >
logical_block_size.  For instance (63 * 512) & (4096 - 1) = 3584.

Your patch would yield 28672 = 4096 * 7 and that's incorrect; LBA 63 is
not aligned on a 4KB boundary...

-- 
Martin K. Petersen	Oracle Linux Engineering
