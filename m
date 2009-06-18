Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZFRTAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZFRTAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZFRTAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:00:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39055
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbZFRTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:00:30 -0400
Date: Thu, 18 Jun 2009 12:00:34 -0700 (PDT)
Message-Id: <20090618.120034.246557840.davem@davemloft.net>
To: rientjes@google.com
Cc: eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
References: <4A396EA2.60705@gmail.com>
	<20090617.160840.58571632.davem@davemloft.net>
	<alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Thu, 18 Jun 2009 09:56:14 -0700 (PDT)

> I disagree, page allocation failure messages show vital information about 
> the state of the VM so that we can find bugs and GFP_ATOMIC allocations 
> are the most common trigger for these diagnostic messages since 
> __GFP_WAIT allocations can trigger direct reclaim (and __GFP_FS 
> allocations can trigger the oom killer) to free memory and will retry the 
> allocation if ~__GFP_NORETRY.

It's COMPLETELY and ABSOLUTELY normal for GFP_ATOMIC allocations to
fail in the networking.

If you warn it will just spam the logs, and on a router forwarding
millions of packets per second are you sure that can ever be sane?

Use statistics and tracing if necessary, but log spam no way...
