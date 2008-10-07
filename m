Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYJGOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYJGOTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYJGOTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:19:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbYJGOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:19:41 -0400
Message-ID: <48EB6F2D.100@linux-foundation.org>
Date: Tue, 07 Oct 2008 09:16:13 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Corey Minyard <minyard@acm.org>, David Miller <davem@davemloft.net>,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <48EA9A59.1090306@acm.org> <20081007083750.GB17079@2ka.mipt.ru>
In-Reply-To: <20081007083750.GB17079@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Mon, Oct 06, 2008 at 06:08:09PM -0500, Corey Minyard (minyard@acm.org) wrote:
>> Would using SLAB_DESTROY_BY_RCU be ok, or would that be too expensive?
> 
> I tested skb destruction via RCU path, and got 2.5 times worse numbers
> with small-packets-bulk-transfer workload.

Was this with regular RCU freeing? This will cool down the cacheline before
frees. You need SLAB_DESTROY_BY_RCU to keep the objects cache hot.


