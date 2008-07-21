Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbYGUGTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbYGUGTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYGUGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:18:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:36911 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYGUGSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:18:55 -0400
Subject: Re: [PATCH]: libata-scsi: Don't start hotplug work queue
	if	hotplug is	disabled
From: Chunbo Luo <chunbo.luo@windriver.com>
Reply-To: chunbo.luo@windriver.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48841331.60008@kernel.org>
References: <1214533246.6284.10.camel@pek-cluo>
	 <48809BA0.8060500@kernel.org> <1216609385.6358.14.camel@pek-cluo>
	 <48841331.60008@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Wind River
Date: Mon, 21 Jul 2008 14:16:02 +0800
Message-Id: <1216620962.29890.3.camel@pek-cluo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 21 Jul 2008 06:18:02.0782 (UTC) FILETIME=[87E61BE0:01C8EAF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 13:40 +0900, Tejun Heo wrote:
> Chunbo Luo wrote:
> >> And this message has nothing to do with SCSI.  It's printed by libata
> >> proper for several drivers which don't support ATAPI.  Did the patch
> >> really kill the warning messages?  Can you please post full boot log
> >> from 2.6.26 w/o the patch?
> > 
> > If the drivers don't support ATAPI, the hotplug task cannot find linked device,
> > and it will start the hotplug task again. Which will print messages continously 
> > like this.
> > 
> > ----------
> > ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> > ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> > ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> > ﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> > ...
> > ------------
> > 
> > We should find a way to avoid this kind of noisy warning messages.
> > 
> > This patch cannot kill the warning messages, but it can avoid the
> > duplicate warning messages.
> 
> Hmmm... yeah, indeed.  That check is located at rather strange place.
> Can you please test the attached patch?

I tested the attached patch on mpc7448hpc2 ,it worked. It can avoid the
multiple warning messages.

Thanks!
Chunbo
> 
> Thanks.
> 
