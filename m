Return-Path: <linux-kernel-owner+w=401wt.eu-S1031321AbXDZQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031321AbXDZQM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031317AbXDZQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:12:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39966 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031323AbXDZQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:12:22 -0400
Date: Thu, 26 Apr 2007 17:11:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Gud <gud@ksu.edu>
Cc: Jeff Dike <jdike@addtoit.com>, Valerie Henson <val_henson@linux.intel.com>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426171134.5ce3bb6a@the-village.bc.nu>
In-Reply-To: <4630CAEC.2050909@ksu.edu>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
	<17965.60841.900376.524639@gargle.gargle.HOWL>
	<Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>
	<17966.23512.363955.141489@gargle.gargle.HOWL>
	<Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz>
	<17967.15531.450627.972572@gargle.gargle.HOWL>
	<20070425224710.GB16129@nifty>
	<20070426141455.GA6155@c2.user-mode-linux.org>
	<4630CAEC.2050909@ksu.edu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Preventive measures are taken to limit only one continuation inode per 
> file per chunk. This can be done easily in the chunk allocation 
> algorithm for disk space. Although I'm not quite sure what you mean by 

How are you handling the allocation in this situation, are you assuming
that a chunk is "out of bounds" because part of a file already lives on
it or simply keeping a single inode per chunk which has multiple sparse
pieces of the file on it ?

ie if I write 0-8MB to chunk A and then 8-16 to chunk B can I write
16-24MB to chunk A producing a single inode of 0-8 16-24, or does it have
to find another chunk to use ?
