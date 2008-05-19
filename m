Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYESOmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYESOmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYESOmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:42:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbYESOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:42:30 -0400
Message-ID: <483191AA.9030202@firstfloor.org>
Date: Mon, 19 May 2008 16:41:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: swhiteho@redhat.com, sfrench@samba.org, vandrove@vc.cvut.cz,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/11] Remove BKL from remote_llseek
References: <20080519231.561421028@firstfloor.org>	 <20080519123110.930491B41FF@basil.firstfloor.org> <1211205524.7911.14.camel@localhost>
In-Reply-To: <1211205524.7911.14.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The one case in nfs_file_llseek() where we might care is the call to
> nfs_revalidate_file_size() ﻿('cos I still haven't finished auditing BKL
> dependencies in the inode attributes). However that case should already
> be covered without introducing any new lock_kernel/unlock_kernel calls
> since __nfs_revalidate_inode() already grabs the BKL.

Thanks. I'll keep it for now with the explicit lock_kernel() and when you're 
finished  your audit and the patches are in before you can just remove them 
yourself. I guess that's the best way to handle it.

-Andi


