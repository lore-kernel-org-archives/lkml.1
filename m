Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZHSQPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZHSQPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZHSQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:15:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40338 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468AbZHSQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:15:03 -0400
Date: Wed, 19 Aug 2009 17:15:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
Message-ID: <20090819171510.68bef78f@lxorguk.ukuu.org.uk>
In-Reply-To: <4A8C2012.6090809@gmail.com>
References: <20090819112554.GY12579@kernel.dk>
	<4A8BE932.5090300@garzik.org>
	<20090819120458.GZ12579@kernel.dk>
	<4A8BECC2.2060607@rtr.ca>
	<20090819122320.GA12579@kernel.dk>
	<4A8BFC79.1000004@garzik.org>
	<4A8BFDE2.1010904@garzik.org>
	<4A8C0820.8060200@gmail.com>
	<20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
	<4A8C2012.6090809@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are work threads per workqueue?  Combined with per-cpu binding,
> dynamic thread pool per workqueue can get quite messy.  All three
> factors end up getting multiplied - ie. #cpus * pool_size which can be
> enlarged by the same work hopping around * #workqueues.

Stop a moment. Exactly how many work queue users need per cpu binding
wizardry ?

> Another problem is that if we apply this to the existing default
> workqueue which is used by many different supposed-to-be-short works
> in essentially batch mode, we might end up enlarging cache footprint
> by scheduling unnecessarily many threads, which, in tight situations,
> might show up as small but noticeable performance regression.

Only if you make the default assumed max wait time for the work too low -
its a tunable behaviour in fact.

Alan
