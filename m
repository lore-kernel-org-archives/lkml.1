Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXDADNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXDADNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 23:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXDADNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 23:13:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:7193 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXDADNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 23:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AwhqhOSGCGkpPtlhFcWW6D6KjPFuUJy+CUkRC3KqAXt+6/hZNpHSCo2wp1/2r9AOcUNDb8aQMs3gi5siccKLYsm8BHLZ73UVWhtq4OYJFQ1gr1xAtGrgDOIo006/am9roLJEF+/yVTTBgbJampMTczaP4rFKTpcwAq/nRkFnHYk=
Message-ID: <b6a2187b0703312013o6c305e00v829894f215812550@mail.gmail.com>
Date: Sun, 1 Apr 2007 11:13:31 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Cc: linux-pm@lists.linux-foundation.org, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, "Jens Axboe" <jens.axboe@oracle.com>,
       jgarzik@pobox.com, "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200703311232.57505.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070331170245.GA9244@elte.hu>
	 <200703311118.55132.david-b@pacbell.net>
	 <200703311232.57505.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, David Brownell <david-b@pacbell.net> wrote:
> for those will all get grouped together ... suspended "very late" and
> resumed "very early", regardless of when they get registered.  Pretty
> much the driver model parts of what Linus was suggesting; clockevent
> bits would still be needed.

I tested your patch with CONFIG_NO_HZ=y, but it still hangs while
suspending to disk (before the percent saving).

But one discovery. I get tired of all these hangs, so I decided to
press some keys and the power button. Accidentally, the suspend
proceeded and successfully suspended!

I tried many more times, and discovered that to proceed with the
suspend, hit any 4 keys slowly. (e.g. "F1 F2 F3 F4", or "1 2 3 4").

My .config has CONFIG_NO_HZ=y and CONFIG_HIGH_RES_TIMERS=y, but I
suppose CONFIG_HIGH_RES_TIMERS=y gots nothing to do with the hang.

I went back with my vanilla 2.6.21-rc5 with Maxim's patch, and with
hitting the keys, I could suspend to disk with CONFIG_NO_HZ=y and
CONFIG_HIGH_RES_TIMERS=y.

Jeff.
