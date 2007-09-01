Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbXIABL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbXIABL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXIABLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:11:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44296 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbXIABLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:11:47 -0400
Date: Fri, 31 Aug 2007 18:11:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@lst.de>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mingming Cao <cmm@us.ibm.com>
Subject: Re: [00/36] Large Blocksize Support V6
In-Reply-To: <Pine.LNX.4.64.0708281254070.16473@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0708311804550.20144@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828192034.GA13883@lst.de>
 <Pine.LNX.4.64.0708281254070.16473@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to some help Mingming Cao we now have support for extX with up to 
64k blocksize. There were several issues in the jbd layer.... (The ext2 
patch that Christoph complained about was dropped).

The patchset can be tested (assuming one has a current git tree)

git checkout -b largeblock
git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/largeblocksize.git largeblock

... Fiddle around with large blocksize functionality....

git checkout master

... Back to Linus' tree.

git branch -D largeblock

... Get rid of it.


commit ed541c23b8e71a0217fd96d1b421992fdd7519df
Author: Mingming Cao <cmm@us.ibm.com>

    JBD: blocks reservation fix for large block support

commit a1eaa33cf1600f18e961f1cf5c87820bca44df08
Author: Christoph Lameter <clameter@sgi.com>

    Teach jbd/jbd2 slab management to support >8k block size.

commit 8199976e04333d66202edcaec6cef46771ed194e
Author: Christoph Lameter <clameter@sgi.com>

    Do not use f_mapping in simple_prepare_write()

commit ac4d742ff3b3526d4c22d5b42e9f9fcc99881a8c
Author: Mingming Cao <cmm@us.ibm.com>

    ext4: fix rec_len overflow with 64KB block size

commit f336a2d00e7c79500ff30fad40f6e3090319cbe7
Author: Mingming Cao <cmm@us.ibm.com>

    ext3: fix rec_len overflow with 64KB block size

commit b0c1b74d42cce96c592f8d13b7b842a3e07b0273
Author: Christoph Lameter <christoph@qirst.com>

    ext2: fix rec_len overflow with 64KB block size

commit 01229e6a2e84178a8b8467930c113a0096c069f2
Author: Mingming Cao <cmm@us.ibm.com>

    Large Blocksize support for Ext2/3/4


