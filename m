Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXEBPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXEBPoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXEBPoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:44:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50812 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbXEBPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:44:23 -0400
Date: Thu, 3 May 2007 01:44:14 +1000
From: David Chinner <dgc@sgi.com>
To: "Cabot, Mason B" <mason.b.cabot@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502154414.GB77450368@melbourne.sgi.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 01:43:18PM -0700, Cabot, Mason B wrote:
> Hello all,
> 
> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.
> 
> I've posted a brief paper on Intel's OSS website
> (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> it a read and let me know what you think. In particular, I'd like to
> arrive at the right place to fix this problem: is it in the filesystem,
> VFS, or Samba?

As I commented on IRC to Val Henson - the XFS performance indicates
that it is not a VFS or Samba problem.

I'd say it's probably delayed allocation that is making the
difference here - no allocation occurs on the single byte writes, it
occurs when the larger data writes are flushed to disk. Hence no
adverse fragmentation will occur and there wil be no extra
allocations being done.

Hence I think it's probably a filesystm problem - it would be
interesting to see how ext4 performs on this workload....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
