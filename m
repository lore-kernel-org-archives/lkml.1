Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYBSV7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYBSV7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYBSV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:58:58 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60711 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541AbYBSV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:58:57 -0500
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200802192159.m1JLxRva003071@sabah.engr.sgi.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in
To: randy.dunlap@oracle.com (Randy Dunlap)
Date: Tue, 19 Feb 2008 13:59:27 -0800 (PST)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080219132525.a81e8264.randy.dunlap@oracle.com> from "Randy Dunlap" at Feb 19, 2008 01:25:25 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Feb 19 13:25:25 2008, randy.dunlap@oracle.com wrote:
> 
> > +u64 inline jiffies_64_to_usecs(const u64 j)
> > +{
> > +	u64 tmp = j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1;
> > +	do_div(tmp, HZ_TO_USEC_DEN);
> 
> do_div() is:
>  * The semantics of do_div() are:
>  *
>  * uint32_t do_div(uint64_t *n, uint32_t base)
> 
> Maybe you want div64_64().
> 
> > +	return tmp;
> > +}
> > +EXPORT_SYMBOL(jiffies_64_to_usecs);
> > +

In include/asm-generic/div64.h, div64_64(uint64_t dividend, uint64_t divisor)
just returns (dividend / divisor).  Isn't this the same as what I had before
in jiffies_64_to_usecs(), except that the arguments are of type u64?

Jonathan
