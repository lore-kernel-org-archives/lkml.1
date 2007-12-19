Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbXLSEJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbXLSEJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 23:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXLSEJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 23:09:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40662 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXLSEJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 23:09:45 -0500
Date: Wed, 19 Dec 2007 13:09:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       lee.shermerhorn@hp.com, Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <200712191148.06506.nickpiggin@yahoo.com.au>
References: <20071218211548.784184591@redhat.com> <200712191148.06506.nickpiggin@yahoo.com.au>
Message-Id: <20071219124513.9853.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > rmap:  try_to_unmap_file() required new cond_resched_rwlock().
> > To reduce code duplication, I recast cond_resched_lock() as a
> > [static inline] wrapper around reworked cond_sched_lock() =>
> > __cond_resched_lock(void *lock, int type).
> > New cond_resched_rwlock() implemented as another wrapper.
> 
> Reader/writer locks really suck in terms of fairness and starvation,
> especially when the read-side is common and frequent. (also, single
> threaded performance of the read-side is worse).

Agreed.

rwlock got bad performance some case. (especially on many cpu machine)

if many cpu grab read-lock on and off on many cpu system.
then at least 1 cpu always grab read lock and the cpu of waiting write-lock 
never get lock.

threrefore, rwlock often make performance weakness of stress.


I want know testcase for this patch and run it.
Do you have it?


/kosaki


