Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYLPTPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYLPTPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYLPTPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:15:00 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45815 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYLPTO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PZuFPht2/D3C/J6tnxNnzRLYVQR6PAWpWegRY+2f89uYBKbeXlnrd2xX4aBOn+ZfG7
         zhz3ddv38cKRJ6RaLTU6/YXODBxzmoFCja1ZDlPAoxB3NRiZIhc23YNl/BrHGSYyEXI8
         ujQa/MsMEpRmFaoeUDqgkIJTsZO4QBocIB5vA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 1/6] ide: fix setting nIEN on idle devices
Date: Tue, 16 Dec 2008 19:57:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain> <20081213233932.4653.97088.sendpatchset@localhost.localdomain> <20081214070620.GB31552@1wt.eu>
In-Reply-To: <20081214070620.GB31552@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812161957.52419.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 December 2008, Willy Tarreau wrote:
> Hi Bart,
> 
> On Sun, Dec 14, 2008 at 12:39:32AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: fix setting nIEN on idle devices
> > 
> > Fix do_ide_request() to operate on previous device / port instead of
> > the current one.  The original code was wrong since at least Feb 2002
> > (2.4.0 timeframe).
> 
> What could be the impact of this bug ? Should I backport your fix to 2.4 ?

The fix results in better handling of unexpected IRQs on serialized IDE
ports.  However since unexpected IRQs coming from a device is not something
we should normally see and I don't recall seeing any bugreports that would
be potentially closed by this fix I don't think that there is an urgent need
to backport it (thanks for caring about 2.4.x users anyway!).

Thanks,
Bart
