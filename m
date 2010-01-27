Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779Ab0A0XyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0A0XyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569Ab0A0XyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:54:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51552
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab0A0XyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:54:14 -0500
Date: Wed, 27 Jan 2010 15:54:23 -0800 (PST)
Message-Id: <20100127.155423.169231741.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: mbreuer@majjas.com, jarkao2@gmail.com, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mchan@broadcom.com, pcnet32@verizon.net, romieu@fr.zoreil.com,
       mcarlson@broadcom.com
Subject: Re: Hang: 2.6.32.4 sky2/DMAR
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100127094531.53c85aa7@nehalam>
References: <20100127085049.5b5048e9@nehalam>
	<4B60707F.1000608@majjas.com>
	<20100127094531.53c85aa7@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 27 Jan 2010 09:45:31 -0800

> Setting it to 1 causes driver to never go through the dma_sync_single/memcpy
> path.  Perhaps the code for DMAR doesn't do dma_sync_single_for_cpu
> properly, or the value passed to sync_single_for_cpu doesn't account for
> all the overhead of padding and/or ether header.

For the millionth time...

DMAR does not implement any of the DMA SYNC operations, they are set
to NULL in the dma ops vector, and thus are NOPs.
