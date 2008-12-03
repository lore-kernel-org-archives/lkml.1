Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYLCBsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYLCBsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYLCBsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:48:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44542 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYLCBsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:48:21 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: mengsanshui@yahoo.com.cn
Subject: Re: question related page frame reclaim on embedded system
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <816384.38683.qm@web15703.mail.cnb.yahoo.com>
References: <20081202203601.1D24.KOSAKI.MOTOHIRO@jp.fujitsu.com> <816384.38683.qm@web15703.mail.cnb.yahoo.com>
Message-Id: <20081203103641.1D32.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  3 Dec 2008 10:48:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi,Kosaki
> 
> Thank you very much .
> I have another question about share memory . Assume a process create a share memory ,
> seems the page that the process used can not be discard or swap out

No. Linux can swap out COW shared memory too. see swap cache related code.
Also, Linux can discard non-dirty and file mapped shared page.

but, yes.
Linux can't discart dirty or anonymous mapped page.


> when they are no longer used by any process or no swap space .
> 
> 1.whether the maped page of the share memory is persistent in system until
>   system restart ? if not how page frame reclaiming process it ? 

No.
Linux manage page reference count.
forrk increment it. exit decrement it.
So, when process exiting, Linux can discard non used page immediately.

IOW, reclaim provide "page discard/swap although page is still used" mechanism.


