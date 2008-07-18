Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbYGRN5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbYGRN5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYGRN5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:57:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811AbYGRN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:57:13 -0400
Message-ID: <4880A0EF.9030006@linux-foundation.org>
Date: Fri, 18 Jul 2008 08:55:59 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       johnpol@2ka.mipt.ru
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> INFO: 0xf658ae9c-0xf658ae9c. First byte 0x6a instead of 0x6b
> 
> 0x6b is POISON_FREE so 0x6a is one bit corruption.

Typically this means that a refcount at the head of the object was decremented. But the object was already freed.
