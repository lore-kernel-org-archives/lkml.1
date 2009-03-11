Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZCKAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZCKAEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZCKAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:04:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:58388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZCKAEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:04:11 -0400
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
In-Reply-To: <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 11:01:51 +1100
Message-Id: <1236729711.7086.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 15:35 +0000, Alan Cox wrote:
> > This primary purpose of this macro is to poll on a hardware register until a
> > status bit changes.  The timeout ensures that the loop still terminates if the
> > bit doesn't change as expected.  This macro makes it easier for driver
> > developers to perform this kind of operation properly.
> 
> NAK this - on a lot of platforms 1uS is the wrong timescale. Also we
> shouldn't be encouraging this kind of polling by making it very easy to
> write.
> 
> It might be a useful internal macro for some freescale drivers but if so
> it doesn't belong in the core headers

I don't totally agree with your reasoning here Alan.

A simple fact of life is that drivers -will- do that sort spinning. They
don't always have a choice. Now do we want all drivers to do it
differently and get it wrong (such as not having timeouts etc...) or do
we provide a helper that has the added advantage of allowing us a lot
more easily to audit them ?

Hell, we can even make the helper warn if called with a too high timeout
value or that sort of thing...

I think it's all benefit to move that sort of cruft to a generic helper
like that in the long run.

Cheers,
Ben.
 

