Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZCFJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZCFJSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZCFJSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:18:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:50162 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZCFJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:18:04 -0500
Date: Fri, 6 Mar 2009 18:13:22 +0900
To: jens.axboe@oracle.com
Cc: scameron@beardog.cca.cpqcorp.net, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, mike.miller@hp.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090306085529.GP11787@kernel.dk>
References: <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
	<20090305142114.GG15340@beardog.cca.cpqcorp.net>
	<20090306085529.GP11787@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090306181302X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 18:13:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 09:55:29 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > If it's settable at init time, that would probably be enough for
> > the vast majority of uses (and more flexible than what we have now)
> > and a lot easier to implement.
> 
> Completely agree, don't waste time implementing something that nobody
> will ever touch. The only reason to fiddle with such a setting would be
> to increase it, because ios are too small. And even finding out that the
> segment limit is the one killing you would take some insight and work
> from the user.
> 
> Just make it Big Enough to cover most cases. 32 is definitely small, 256
> entries would get you 1MB ios which I guess is more appropriate.

I guess that the dynamic scheme is overdoing but seems that vendors
like some way to configure the sg entry size. The new MPT2SAS driver
has SCSI_MPT2SAS_MAX_SGE kernel config option:

http://marc.info/?l=linux-scsi&m=123619290803547&w=2


The kernel module option for this might be appropriate.
