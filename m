Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZLNQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZLNQCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbZLNQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:02:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:35352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbZLNQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:02:46 -0500
Date: Mon, 14 Dec 2009 08:04:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 2/8] Mark sleep_on as deprecated
Message-ID: <20091214080452.18516dc1@infradead.org>
In-Reply-To: <20091214130302.GA25797@infradead.org>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214212351.BBB4.A69D9226@jp.fujitsu.com>
	<20091214130302.GA25797@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 08:03:02 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Dec 14, 2009 at 09:24:40PM +0900, KOSAKI Motohiro wrote:
> > 
> > 
> > sleep_on() function is SMP and/or kernel preemption unsafe. we
> > shouldn't use it on new code.
> 
> And the best way to archive this is to remove the function.
> 
> In Linus' current tree I find:
> 
>  - 5 instances of sleep_on(), all in old and obscure block drivers
>  - 2 instances of sleep_on_timeout(), both in old and obscure drivers 

these should both die; the sleep_on() ones using BROKEN in Kconfig..
.. sleep_on() has not worked in the 2.6 series ever.... ;)


>  
>  - 28 instances of interruptible_sleep_on_timeout(), mostly in obscure
>    drivers with a high concentration in the old oss core which should
> be killed anyway.  And unfortunately a few relatively recent additions
>    like the SGI xpc driver or usbvision driver

can we also make sure that checkpatch.pl catches any new addition?
(not saying checkpatch.pl is the end-all, but the people who do run it
at least have now have a chance ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
