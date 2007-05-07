Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXEGTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXEGTtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXEGTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:49:37 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:57564 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbXEGTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:49:36 -0400
Date: Mon, 7 May 2007 11:51:44 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Message-ID: <20070507185144.GC6031@schatzie.adilger.int>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20070506222626.GA25632@janus> <20070506214014.8b7451ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506214014.8b7451ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 06, 2007  21:40 -0700, Andrew Morton wrote:
> On Mon, 7 May 2007 00:26:26 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:
> 
> > 2.6.20.6, FC4:
> > 
> > I created a 91248k ext3 fs with 4k blocksize:
> > 
> > Next, I tried to resize it to about 3G using ext2online while mounted:
> > 
> > At that time the kernel said:
> > 
> > |JBD: ext2online wants too many credits (744 > 256)
> > 
> > What is the limitation I should be aware of? Has it something to do with
> > the journal log size?

Yes, for very small filesystems the default journal size is only 4MB, and
the maximum transaction size is 1MB (256 blocks).

If the filesystem was 128MB or larger in the initial mke2fs then the
journal would be 16MB and the resize would get up to 1024 blocks for
the transaction.

I'm not sure what the right solution is for this.  If you know you will
be resizing the fs you could increase the initial journal size at mke2fs
time (-J size=16).  Alternately, it is possible resize to an intermediate
size and then delete and recreate the journal via tune2fs (which would
be the larger size by default) but that can only be done offline.  

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

