Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbXEVBjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbXEVBjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbXEVBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:39:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:44861 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbXEVBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CxzPrJPxyq+g4pE1WeDgtbwPqmB3hfbQWNfaNLMbXMg/4t1MlVeHYAkBky/sDRFT4DPih0Ar1iFVmDn++VoBulEu7wq1JPSUGgVpv7gjDzEivmePLF3H8d2xOTgUD+VnkHiE5APzkLQkW5W3cMvcrWAKmF+56LxnR6u7aeDSDec=
Message-ID: <46524345.5040505@gmail.com>
Date: Tue, 22 May 2007 03:11:33 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Sandeen <sandeen@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] - fix oops in sysfs_readdir
References: <4651E0C9.3080609@redhat.com>	<20070521153935.b549db8f.akpm@linux-foundation.org>	<465236EF.40102@redhat.com> <20070521175445.adab3608.akpm@linux-foundation.org>
In-Reply-To: <20070521175445.adab3608.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Actually, someone (eg distros) looking at Tejun's changelog would still be
> struggling to answer the question "do I need this".  The one thing it
> claims to fix is "duplicate inode numbers".  But why is that a problem? 
> What are the user-visible consequences of not merging the patch?  Unobvious.

The oops part is explained in #2.  sysfs_dirent->s_dentry can go away
anytime and the original code accesses it without any synchronization,
so it can end up dereferencing NULL or access already freed memory.
And, yeah, this is another place where reclaim-related oops occurs.

-- 
tejun
