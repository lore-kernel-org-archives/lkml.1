Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXBVNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXBVNla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXBVNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:41:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48437
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbXBVNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:41:29 -0500
Date: Thu, 22 Feb 2007 05:41:27 -0800 (PST)
Message-Id: <20070222.054127.104035694.davem@davemloft.net>
To: johnpol@2ka.mipt.ru
Cc: arjan@infradead.org, mingo@elte.hu, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070222123929.GA5208@2ka.mipt.ru>
References: <20070222113148.GA3781@2ka.mipt.ru>
	<1172145159.3531.253.camel@laptopd505.fenrus.org>
	<20070222123929.GA5208@2ka.mipt.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Thu, 22 Feb 2007 15:39:30 +0300

> It does not matter - even with threads cost of having thousands of
> threads is _too_ expensive. So, IMO, it is wrong to have to create 
> 20k threads for the simple web server which only sends one index page to
> 80k connections with 4k connections per seconds rate.
> 
> Just have that example in mind - more than 20k blocks in 80k connections 
> over gigabit lan, and it is likely optimistic result, when designing new 
> type of AIO.

I totally agree with Evgeniy on these points.

Using things like syslets and threadlets for networking I/O
is not a very good idea.  Blocking is more the norm than the
exception for networking I/O.

