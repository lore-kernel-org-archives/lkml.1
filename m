Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbXBVRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbXBVRRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXBVRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:17:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37632
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbXBVRRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:17:38 -0500
Date: Thu, 22 Feb 2007 09:17:35 -0800 (PST)
Message-Id: <20070222.091735.30182079.davem@davemloft.net>
To: mingo@elte.hu
Cc: johnpol@2ka.mipt.ru, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070222151509.GA13670@elte.hu>
References: <20070222143145.GA3246@elte.hu>
	<20070222.064704.71093028.davem@davemloft.net>
	<20070222151509.GA13670@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 22 Feb 2007 16:15:09 +0100

> furthermore, in a real webserver there's a whole lot of other stuff 
> happening too: VFS blocking, mutex/lock blocking, memory pressure 
> blocking, filesystem blocking, etc., etc. Threadlets/syslets cover them 
> /all/ and never hold up the primary context: as long as there's more 
> requests to process, they will be processed. Plus other important 
> networked workloads, like fileservers are typically on fast LANs and 
> those requests are very much a fire-and-forget matter most of the time.

I expect clients of a fileserver to cause the server to block in
places such as tcp_sendmsg() as much if not more so than a webserver
:-)

But yes, it should all be tested, for sure.
