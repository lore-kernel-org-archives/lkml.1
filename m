Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXCTUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXCTUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXCTUdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:33:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47305 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbXCTUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:33:42 -0400
Date: Tue, 20 Mar 2007 21:36:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org,
       dhowells@redhat.com
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #3]
Message-ID: <20070320213657.15afe5fa@lxorguk.ukuu.org.uk>
In-Reply-To: <20070320195856.12853.63473.stgit@warthog.cambridge.redhat.com>
References: <20070320195856.12853.63473.stgit@warthog.cambridge.redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok quickly going over the code that hasn't made the list

- recvmsg not supporting MSG_TRUNC is rather weird and really ought to be
fixed one day as its useful to find out the sizeof message pending when
combined with MSG_PEEK

- RXRPC_MIN_SECURITY_LEVEL reads into rx->min_sec_level and then if it is
invalid reports an error but doesn't restore the valid level

- Why does rxrpc_writable always return 0 ?

- rxrpc_process_soft_ACKs doesn't itself limit and check acns->nAcks is
always below RXRPC_MAXACKS, as this is a stakc variable it ought to be
paranoid about it. I think its ok from the caller check but its very hard
to prove...


It needs a lot more eyes/review due to the complexity and network
exposure though - not your fault, whoever designed RXRPC's 8)
