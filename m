Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYFXQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYFXQa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYFXQaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:30:21 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:57625 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYFXQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:30:20 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: david safford <safford@watson.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528012242.a0e98d87.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Jun 2008 12:28:50 -0400
Message-Id: <1214324930.3262.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote:

> - I see lots of user file I/O being done from within the kernel. 
>   This makes eyebrows raise.  Also some other eyebrow-raising
>   file-related things in there.
> 
> Generally: the code is all moderately intrusive into the VFS and this
> sort of thing does need careful explanation and justification, please. 
> Once we have some understanding of what you're trying to achieve here
> we will inevitably ask "can't that be done in userspace".  So it would
> be best if your description were to preemptively answer all that.  
> 
> 
Sorry about this delayed response - we are about to repost for RFC, and
noticed we missed responding to this.

The Trusted Computing (TPM) model requires that all files be measured,
(hashed) and the measurement committed to the hardware TPM before any
data of the file is accessed in any way. In addition, if the measurement
is incorrect, all access to the file must be denied. 

This requirement parallels the LSM mandatory access control decisions
in the inode_permission, bprm, and mmap hooks, and naturally leads to 
IMA hooks in the same locations, with similar functionality, but with
the addition of hashing the data. The code would have to significantly
more complex to do the hashing at these points through userspace.

In addition, doing the hashing in userspace gives significantly poorer
performance. With in-kernel hashing, at boot time, we typically measure
some six thousand files with less than 10% (5 seconds) overhead, which
is acceptable to most users. Anything much slower can be annoying enough
that users will turn the measurement off.

dave safford
