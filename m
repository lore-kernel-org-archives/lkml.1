Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZFWETd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZFWETd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbZFWETY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:19:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49689
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbZFWETX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:19:23 -0400
Date: Mon, 22 Jun 2009 21:19:27 -0700 (PDT)
Message-Id: <20090622.211927.245716932.davem@davemloft.net>
To: acme@redhat.com
Cc: mel@csn.ul.ie, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
 from DCCP
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623023936.GA2721@ghostprotocols.net>
References: <1245685414-8979-4-git-send-email-mel@csn.ul.ie>
	<20090622.161502.74508182.davem@davemloft.net>
	<20090623023936.GA2721@ghostprotocols.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 22 Jun 2009 23:39:36 -0300

> Em Mon, Jun 22, 2009 at 04:15:02PM -0700, David Miller escreveu:
>> It's probably much more appropriate to make this stuff use
>> alloc_large_system_hash(), like TCP does (see net/ipv4/tcp.c
>> tcp_init()).
>> 
>> All of this complicated DCCP hash table size computation code will
>> simply disappear.  And it'll fix the warning too :-)
> 
> He mentioned that in the conversation that lead to this new patch
> series, problem is that alloc_large_system_hash is __init, so when you
> try to load dccp.ko it will not be available.

Fair enough.

It's such an unfortunate duplication of code, it's likely therefore
better to remove the __init tag and export that symbol.
