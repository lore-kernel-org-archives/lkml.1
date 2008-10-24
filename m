Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYJXEzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYJXEzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYJXEyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:54:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36082 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYJXEyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:54:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: kosaki.motohiro@jp.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081024012831.GE5004@wotan.suse.de>
References: <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081024012831.GE5004@wotan.suse.de>
Message-Id: <20081024135149.9C46.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 24 Oct 2008 13:54:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Actually, schedule_on_each_cpu() is very problematic function.
> > it introduce the dependency of all worker on keventd_wq, 
> > but we can't know what lock held by worker in kevend_wq because
> > keventd_wq is widely used out of kernel drivers too.
> > 
> > So, the task of any lock held shouldn't wait on keventd_wq.
> > Its task should use own special purpose work queue.
> 
> I don't see a better way to solve it, other than avoiding lru_add_drain_all

Well,

Unfortunately, lru_add_drain_all is also used some other VM place
(page migration and memory hotplug).
and page migration's usage is the same of this mlock usage.
(1. grab mmap_sem  2.  call lru_add_drain_all)

Then, change mlock usage isn't solution ;-)



