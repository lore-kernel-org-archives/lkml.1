Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbXE1LSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbXE1LSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXE1LR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:17:57 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:56910 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXE1LRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:17:55 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18010.47701.751118.336431@gargle.gargle.HOWL>
Date: Mon, 28 May 2007 15:17:41 +0400
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Newsgroups: gmane.linux.kernel.device-mapper.devel,gmane.linux.file-systems,gmane.linux.raid,gmane.linux.kernel
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown writes:
 > 

[...]

 > Thus the general sequence might be:
 > 
 >   a/ issue all "preceding writes".
 >   b/ issue the commit write with BIO_RW_BARRIER
 >   c/ wait for the commit to complete.
 >          If it was successful - done.
 >          If it failed other than with EOPNOTSUPP, abort
 >          else continue
 >   d/ wait for all 'preceding writes' to complete
 >   e/ call blkdev_issue_flush
 >   f/ issue commit write without BIO_RW_BARRIER
 >   g/ wait for commit write to complete
 >        if it failed, abort
 >   h/ call blkdev_issue
 >   DONE
 > 
 > steps b and c can be left out if it is known that the device does not
 > support barriers.  The only way to discover this to try and see if it
 > fails.
 > 
 > I don't think any filesystem follows all these steps.

It seems that steps b/ -- h/ are quite generic, and can be implemented
once in a generic code (with some synchronization mechanism like
wait-queue at d/).

Nikita.

[...]

 > 
 > Thank you for your attention.
 > 
 > NeilBrown
 > 

Nikita.
