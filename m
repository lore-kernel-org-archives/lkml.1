Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbYD3J0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbYD3J0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbYD3JZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:25:47 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57768 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519AbYD3JZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:25:46 -0400
To: dave@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, trond.myklebust@fys.uio.no,
       dave@linux.vnet.ibm.com
In-reply-to: <20080429185948.F5D2E512@kernel> (message from Dave Hansen on
	Tue, 29 Apr 2008 11:59:48 -0700)
Subject: Re: [RFC][PATCH 4/5] must hold lock_super() to set initial mount writer
References: <20080429185943.3BA6A050@kernel> <20080429185948.F5D2E512@kernel>
Message-Id: <E1Jr8ZK-0001uW-4s@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Apr 2008 11:25:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We need lock_mnt_writers() during a remount in order
> to keep mnt->__mnt_writers from changing so that we
> get a consistent look at if a sb currently has anyone
> writing to it.
> 
> But, we need to lock writers out for an extended
> period, even during the ->remount_fs() operation.
> That's because we do conclusively make the fs
> r/o until *after* the ->remount_fs().

So?  Why don't we mark the fs r/o _before_ calling ->remount_fs() and
if that fails, just mark it r/w again.

OK, we'll deny writes in that interval, but I don't see that as a big
problem.  And it would simplify the implementation considerably.

Miklos
