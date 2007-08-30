Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXH3Ajj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXH3Ajj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXH3Aja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:39:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41501 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756825AbXH3Aj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:39:29 -0400
Date: Wed, 29 Aug 2007 17:39:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@kernel.org>
cc: Jan Dittmer <jdi@l4x.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
In-Reply-To: <20070829234734.GA26410@stusta.de>
Message-ID: <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com>
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org>
 <20070829234734.GA26410@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Adrian Bunk wrote:

> Christoph, is your fix in -mm suitable for 2.6.23, or how else should 
> this regression be fixed for 2.6.23?

Looks like this is just alpha and a certain particular compiler version? 
You may get away with adding

void __kmalloc_size_too_large(void)
{
	BUG();
}

somewhere if you use the particular compiler version causing trouble. 
The compiler will then generate some useless code wasting processor 
cycles due to not folding constants but it should(tm) work.
