Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYI3RhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYI3RhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYI3RhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:37:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbYI3RhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:37:03 -0400
Message-ID: <48E26388.30202@linux-foundation.org>
Date: Tue, 30 Sep 2008 12:36:08 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
References: <1222787736.2995.24.camel@castor.localdomain>	 <48E2480A.9090003@linux-foundation.org> <1222791638.2995.41.camel@castor.localdomain>
In-Reply-To: <1222791638.2995.41.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:

> Yes, using vprintk is better but you still have this path :
> ( with your patch applied)
> 
> 	object_err -> slab_bug(208) -> printk(216)
> instead of 
> 	object_err -> slab_bug_message(8) -> printk(216)
> 
> unfortunately the overhead for having var_args is pretty big, at least
> on x86_64. I haven't measured it on 32 bit yet.

Really 208 bytes for a va arg parameter declaration? I expected it to be
simply a null terminated pointer list.

