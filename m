Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZCWIvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZCWIvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZCWIvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:51:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:59249 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbZCWIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dBo8bhFyx2XiAG4YZny4g+qtgjxe9xUL88PdbxNLp40rWuIfxvc6Yca3CZ0KsMeXTu
         krr3K2xI3C6AUtzfNPDjjtyM7thykOcENL79plWXmFA6nOVCIaue+iV5D70u2Y3DNLen
         +kWXCOXjSSWO4fGZCb/CsOqv5RF6+65cMcUu8=
Date: Mon, 23 Mar 2009 08:50:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, vernux@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090323085058.GC4976@ff.dom.local>
References: <20090320232943.GA3024@ami.dom.local> <49C74927.7020008@cosmosbay.com> <20090323.013749.122944803.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323.013749.122944803.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 01:37:49AM -0700, David Miller wrote:
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 23 Mar 2009 09:32:39 +0100
> 
> > I dont understand, doesnt it defeat the ticket spinlock thing and fairness ?
> > 
> > Thread doing __qdisc_run() already owns the __QDISC_STATE_RUNNING bit.
> 
> Right.
> 
> Remember, the way this is designed is that if there is a busy
> cpu taking packets out of the queue and putting them into the
> device then other cpus will simply add to the queue and immediately
> return.

But this "busy cpu" can't take packets out of the queue when it's
waiting on the contended spinlock. Anyway, it's only for testing,
and I didn't say it has to be right.

Jarek P.
