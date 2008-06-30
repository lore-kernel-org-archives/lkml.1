Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYF3Ecw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYF3Ecw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYF3Ecn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:32:43 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:50385 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYF3Ecm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:32:42 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking 
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       mhalcrow@us.ibm.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
Date: Mon, 30 Jun 2008 13:31:57 +0900
Message-ID: <8725.1214800317@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hugh Dickins:
> LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
> unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
> seqcount update: fixed by taking i_lock around i_size_write when 32-bit SMP.

I don't know why dst->i_lock is affected by src->i_size_seqcount.
Do you mean that your test issued write(2) to the lower/actual file so
frequently that i_size_read() in unionfs always failed?

Is your test
iogen01 export LTPROOT; rwtest -N iogen01 -i 120s -s read,write -Da -Dv -n 2 500b:doio.f1.$$ 1000b:doio.f2.$$
line in runtest/fs?


Junjiro Okajima
