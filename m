Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXFMV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXFMV1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXFMV1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:27:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbXFMV1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:27:37 -0400
Message-ID: <46706140.6040502@redhat.com>
Date: Wed, 13 Jun 2007 17:27:28 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Rich Coe <Richard.Coe@med.ge.com>
CC: torvalds@osdl.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: PATCH: udf fs corruption on linux-2.6
References: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
In-Reply-To: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2007 04:48 PM, Rich Coe wrote:
> Hi Linus, 
> 
> This patch fixes directory and missing files corruption in fs/udf which
> occurs on all known 2.6 releases.
> 
> The corruption occurs because blocks which were pre-alloc'd for a directory 
> are released back to the fs freelist, but the inode's alloc block information
> is not updated to reflect this.
> 
> You would not see corruption if the number of files in any directory is 
> less than 41, because the pre-alloc routine does not allocate blocks for the
> directory until the number of files is over 40.
> 
> The problem occurs during unmounting because fs/udf incorrectly calls 
> udf_discard_prealloc() from udf_clear_inode().  udf_discard_prealloc() will
> update the inode and schedule it for write, but no write will ever occur 
> because the fs is in the process of being umount'd. 
> 
> The solution is to add a put_inode routine to update the inode contents
> and release the pre-alloc'd blocks to disk prior to clearing the inode
> from the kernel.

http://lkml.org/lkml/2007/6/11/79

