Return-Path: <linux-kernel-owner+w=401wt.eu-S1030515AbXB0A6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515AbXB0A6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965150AbXB0A6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:58:42 -0500
Received: from [12.22.49.110] ([12.22.49.110]:29448 "EHLO stargate.chelsio.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbXB0A6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:58:41 -0500
Message-ID: <45E38181.5030409@chelsio.com>
Date: Mon, 26 Feb 2007 16:55:29 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, divy@chelsio.com, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
References: <20070225004423.20903.17036.stgit@localhost.localdomain> <20070226051304.GA13626@infradead.org>
In-Reply-To: <20070226051304.GA13626@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2007 00:55:32.0183 (UTC) FILETIME=[FB5E8670:01C75A09]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Feb 24, 2007 at 04:44:23PM -0800, divy@chelsio.com wrote:
>   
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Add all-in-sw lro support.
>>     
>
> Doing this in a LLDD doesn't sound like a good idea.  Have you
> tried doing this in the core networking code instead?
>   

We have not tried to implement LRO in the core networking code.
Today, the available API for a driver to pass packets up is 
netif_receive_skb/netif_rx.
Our implementation coalesces pages, then gets a skb to point at the 
pages and passes it up to the stack.
LRO in the core networking code would require adding methods to pass up 
data segments in addition to skbs.
HW might also be able to assist LRO by identifying the session an 
incoming packet belongs to,
thus avoiding the session lookup. The API should also allow for the 
driver to indicate such info.

Cheers,
Divy
