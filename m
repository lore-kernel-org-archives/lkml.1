Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXGKFWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXGKFWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbXGKFW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:22:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759885AbXGKFWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:22:24 -0400
Date: Tue, 10 Jul 2007 22:22:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-Id: <20070710222209.5078e20b.akpm@linux-foundation.org>
In-Reply-To: <18068.25879.745638.343290@notabene.brown>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<18068.25879.745638.343290@notabene.brown>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 15:05:27 +1000 Neil Brown <neilb@suse.de> wrote:

> 
> It just occurred to me:
> 
>  If i_version is 64bit, then knfsd would need to be careful when
>  reading it on a 32bit host.  What are the locking rules?
> 
>  Presumably it is only updated under i_mutex protection, but having to
>  get i_mutex to read it would seem a little heavy handed.
> 
>  Should it use a seqlock like i_size?
>  Could we use the same seqlock that i_size uses, or would we need a
>  separate one?
> 

seqlocks are a bit of a pain to use (we've had plenty of deadlocks on the
i_size one).  We could reuse inode.i_lock for this modification.  Its
mandate is "general purpose innermost lock to protect stuff in this inode".


