Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbXI1BV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbXI1BV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXI1BVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:21:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37248 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXI1BVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:21:48 -0400
Date: Thu, 27 Sep 2007 21:21:32 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML - Correctly handle skb allocation failures
Message-ID: <20070928012132.GA10302@c2.user-mode-linux.org>
References: <20070927170126.GA6542@c2.user-mode-linux.org> <20070927165340.fd5dc2d0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927165340.fd5dc2d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:53:40PM -0700, Andrew Morton wrote:
> Still wanna know why it is safe for uml_net_rx to be playing with
> drop_skb when update_drop_skb() could be concurrently reallocating
> and freeing it.

Ah, yes, I missed that point in the horror of my botch last night.

I'll add irqsave/irqrestore to the locking - keep this patch, and I'll
send in a fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
