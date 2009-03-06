Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZCFJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZCFJcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZCFJcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:32:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:36587 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZCFJcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:32:02 -0500
Date: Fri, 6 Mar 2009 18:27:21 +0900
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, scameron@beardog.cca.cpqcorp.net,
       linux-kernel@vger.kernel.org, mike.miller@hp.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090306092114.GS11787@kernel.dk>
References: <20090306085529.GP11787@kernel.dk>
	<20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	<20090306092114.GS11787@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 18:27:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 10:21:14 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> > On Fri, 6 Mar 2009 09:55:29 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > If it's settable at init time, that would probably be enough for
> > > > the vast majority of uses (and more flexible than what we have now)
> > > > and a lot easier to implement.
> > > 
> > > Completely agree, don't waste time implementing something that nobody
> > > will ever touch. The only reason to fiddle with such a setting would be
> > > to increase it, because ios are too small. And even finding out that the
> > > segment limit is the one killing you would take some insight and work
> > > from the user.
> > > 
> > > Just make it Big Enough to cover most cases. 32 is definitely small, 256
> > > entries would get you 1MB ios which I guess is more appropriate.
> > 
> > I guess that the dynamic scheme is overdoing but seems that vendors
> > like some way to configure the sg entry size. The new MPT2SAS driver
> > has SCSI_MPT2SAS_MAX_SGE kernel config option:
> > 
> > http://marc.info/?l=linux-scsi&m=123619290803547&w=2
> > 
> > 
> > The kernel module option for this might be appropriate.
> 
> Dunno, still seems pretty pointless to me. The config option there
> quotes memory consumption as the reason to reduce the number of sg
> entries, however I think that's pretty silly. Additionally, a kernel
> config entry just means that customers will be stuck with a fixed value
> anyway. So I just don't see any merit to doing it that way either.

Yeah, agreed. the kernel config option is pretty pointless. But I'm
not sure that reducing memory consumption is completely pointless.
