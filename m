Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbYBUDqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbYBUDqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYBUDps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:45:48 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:36471 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753718AbYBUDpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:45:46 -0500
In-Reply-To: <47BCD0DF.1050205@chelsio.com>
Subject: Re: [git patches] net driver updates
To: Divy Le Ray <divy@chelsio.com>
Cc: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0.1P July 04, 2006
Message-ID: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Thu, 21 Feb 2008 09:13:49 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 02/21/2008 09:23:25
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Divy,

> > Explain why, so I can include it in the changelog please...
>
> Hi Jeff,
>
> The first part of the patch removes the !netif_queue_stopped(dev).
> It opens the race discussed a while ago between Stephen hemminger and
> David Miller:
> http://marc.info/?l=linux-netdev&m=113383224512427&w=2

I feel this race cannot happen anymore. I think the fix for that race was
to introduce the
__LINK_STATE_QDISC_RUNNING bit thus eliminating any races between CPU's. If
one
CPU has called xmit, the other CPU will enqueue skbs (by holding the
queue_lock) and
exit from qdisc_run since it finds the bit set already.

Thanks,

- KK

