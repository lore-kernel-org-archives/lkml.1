Return-Path: <linux-kernel-owner+w=401wt.eu-S1761087AbYDXRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087AbYDXRdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYDXRdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:33:43 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38572 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYDXRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:33:43 -0400
Date: Thu, 24 Apr 2008 13:29:49 -0400
Message-Id: <200804241729.m3OHTnNx016180@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 15:28:57 BST."
             <20080424142857.GF15214@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424142857.GF15214@ZenIV.linux.org.uk>, Al Viro writes:
> On Thu, Apr 24, 2008 at 04:09:18PM +0200, Miklos Szeredi wrote:
[...]
> FWIW, I'm not all that happy about the way ecryptfs_interpose() is done,
> while we are at it.  We get the sucker opened by whoever steps on given
> place in the tree first, with subsequent operations done using the resulting
> struct file.  With fallback to r/o open.  What happens to somebody who
> tries to open it with enough permissions to do r/w?

Yes, ecryptfs_interpose() calls ecryptfs_init_persistent_file() which calls
dentry_open(O_RDWR).  What's the proposed solution for this in the face of
r/o vfsmounts?  How could ecryptfs avoid calling this dentry_open in the
first place?

For unionfs, all I need is return -EROFS or the like to trigger a possible
copyup.

Erez.
