Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbYDBSo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbYDBSo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYDBSon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:44:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50452
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755190AbYDBSol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:44:41 -0400
Date: Wed, 02 Apr 2008 11:44:41 -0700 (PDT)
Message-Id: <20080402.114441.78726196.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: akpm@linux-foundation.org, csnook@redhat.com, davej@codemonkey.org.uk,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, mchan@broadcom.com
Subject: Re: GFP_ATOMIC page allocation failures.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080402195428.95A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080402.012406.246863209.davem@davemloft.net>
	<20080402175857.959A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080402195428.95A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 02 Apr 2008 19:56:05 +0900

> 
> > ---------------------------------------------------------------------
> > We get rather a lot of reports of page allocation warnings coming out of
> > tg3.  But this driver is know to handle them properly so let's suppress
> > them.
> 
> BTW:
> other person's tg3 allocation failure bug report.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9771

Yes, I know about it.  It will occur for any device
which must use linear RX buffers and supports
>PAGE_SIZE MTUs.

But modern chips are going to support segmentation of
receive packets into multiple individual pages and
therefore not have this order>0 page allocation
requirement.

That is my point.
