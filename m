Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYLDKRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYLDKRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYLDKQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:16:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59634 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910AbYLDKQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:16:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: mengsanshui@yahoo.com.cn
Subject: Re: question related page frame reclaim on embedded system
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <478468.3916.qm@web15702.mail.cnb.yahoo.com>
References: <20081203103641.1D32.KOSAKI.MOTOHIRO@jp.fujitsu.com> <478468.3916.qm@web15702.mail.cnb.yahoo.com>
Message-Id: <20081204191510.1D80.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 19:16:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,Kosaki
> 
> 1. what happens if used IPC share memory ?
>    As i knew IPC share memory  use anonymous mapping ,but not sure my understand is correctly .

Yes.
if you don't free IPC share memory, it remain on the system until reboot.



> 
> Thanks advanced .
> Best Regards.
> Peter
> 
> 
> --- On Wed, 12/3/08, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Subject: Re: question related page frame reclaim on embedded system
> > To: mengsanshui@yahoo.com.cn
> > Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
> > Date: Wednesday, December 3, 2008, 9:48 AM
> > > 
> > > Hi,Kosaki
> > > 
> > > Thank you very much .
> > > I have another question about share memory . Assume a
> > process create a share memory ,
> > > seems the page that the process used can not be
> > discard or swap out
> > 
> > No. Linux can swap out COW shared memory too. see swap
> > cache related code.
> > Also, Linux can discard non-dirty and file mapped shared
> > page.
> > 
> > but, yes.
> > Linux can't discart dirty or anonymous mapped page.
> > 
> > 
> > > when they are no longer used by any process or no swap
> > space .
> > > 
> > > 1.whether the maped page of the share memory is
> > persistent in system until
> > >   system restart ? if not how page frame reclaiming
> > process it ? 
> > 
> > No.
> > Linux manage page reference count.
> > forrk increment it. exit decrement it.
> > So, when process exiting, Linux can discard non used page
> > immediately.
> > 
> > IOW, reclaim provide "page discard/swap although page
> > is still used" mechanism.
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



