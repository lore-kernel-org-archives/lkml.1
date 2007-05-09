Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXEIJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXEIJnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXEIJnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:43:05 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:35511 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEIJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:43:02 -0400
Date: Wed, 9 May 2007 11:43:05 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070509094305.GC28774@linuxtv.org>
References: <20070508121404.17bd97a6.randy.dunlap@oracle.com> <16987.1178675251@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16987.1178675251@lwn.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.76.223
Subject: Re: [RFC/PATCH] doc: volatile considered evil
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007, Jonathan Corbet wrote:
> 
> I just took a shot at turning this into something more like a normal
> document:
> 
> 	http://lwn.net/Articles/233479/

I think the "jiffies variable is special" part misses the
"for stupid legacy reasons" explanation.

According to the other volatile rules one should use
something like that:

extern unsigned long __jiffies;
static inline unsigned long read_ulong(unsigned long *addr)
{
	return *(volatile unsigned long *)addr;
}
static inline unsigned long get_jiffies(void)
{
	return read_ulong(&__jiffies);
}

But of course changing all references to jiffies in the kernel would
be insane, thus jiffies is special "for stupid legacy reasons".

Right?


Johannes
