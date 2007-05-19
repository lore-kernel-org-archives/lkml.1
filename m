Return-Path: <linux-kernel-owner+w=401wt.eu-S1763999AbXESSyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763999AbXESSyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbXESSyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:54:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52131
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbXESSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:54:39 -0400
Date: Sat, 19 May 2007 11:54:42 -0700 (PDT)
Message-Id: <20070519.115442.30184476.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: akpm@linux-foundation.org, dhowells@redhat.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MM : alloc_large_system_hash() can free some memory
 for non power-of-two bucketsize
From: David Miller <davem@davemloft.net>
In-Reply-To: <464F3CCF.2070901@cosmosbay.com>
References: <20070518115454.d3e32f4d.dada1@cosmosbay.com>
	<20070519013724.3d4b74e0.akpm@linux-foundation.org>
	<464F3CCF.2070901@cosmosbay.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Sat, 19 May 2007 20:07:11 +0200

> Maybe David has an idea how this can be done properly ?
> 
> ref : http://marc.info/?l=linux-netdev&m=117706074825048&w=2

You need to use __GFP_COMP or similar to make this splitting+freeing
thing work.

Otherwise the individual pages don't have page references, only
the head page of the high-order page will.
