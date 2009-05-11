Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZEKDVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZEKDVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZEKDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:21:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55896 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZEKDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:21:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: Q: semaphore and kmalloc(GFP_KERNEL)?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <200905110319.n4B3J9hc092830@www262.sakura.ne.jp>
References: <20090511115410.B0EA.A69D9226@jp.fujitsu.com> <200905110319.n4B3J9hc092830@www262.sakura.ne.jp>
Message-Id: <20090511122046.B0ED.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 12:21:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > > Can the kernel detect that we need to let kmalloc() fail and
> > > wake up the writer process so that the writer process releases
> > > the rw_semaphore and reader processes can continue?
> > 
> > it can't. Plus it shouldn't.
> > some caller don't want kmalloc() failure.
> 
> Thanks.
> Then, should I move kmalloc(GFP_KERNEL) to outside the lock whenever possible?

Yes. almost driver does it.
this is generic issue of nested locking.

> (I worry some lock held by the caller interferes kmalloc(GFP_KERNEL).)



