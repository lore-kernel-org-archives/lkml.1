Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXKZJnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXKZJnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXKZJnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:43:41 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50914 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKZJnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:43:40 -0500
Date: Mon, 26 Nov 2007 10:43:29 +0100
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: "peerchen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "pchen" <pchen@nvidia.com>,
       "acurrid" <acurrid@nvidia.com>, mchan@broadcom.com
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT
 platform
Message-ID: <20071126104329.34870fe8@bull.net>
In-Reply-To: <200711251121445151346@gmail.com>
References: <200711251121445151346@gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/11/2007 10:50:55,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/11/2007 10:50:59,
	Serialize complete at 26/11/2007 10:50:59
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 11:21:48 +0800 "peerchen" <peerchen@gmail.com> wrote:

> According to the HyperTransport spec, 'En' indicate if the MSI Mapping is
> active. So it should be set when enable the MSI.
> 

  Cool, I had a patch that added a quirk to enable MSI Mapping on Broadcom's
HT1000 so that the builtin BCM5706S Gigabit Ethernet would use MSI. This one
looks even cleaner.

  As a side note, the bnx2 driver tries to use MSI by default (in the kernel I'm
using - 2.6.21.5-rt10) and falls back to INTx if no interrupt is received within
a reasonable amount of time. If the HT MSI Mapping is not enabled beforehand,
the first MSI message (before reverting to INTx) is not trapped by the bridge
and lands in memory thus corrupting what is there at that time. In my case
it's the mapcount of a struct page in the freelist which is overwritten with
the MSI message.

  Sébastien.
