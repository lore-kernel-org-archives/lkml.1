Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0BOHRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:17:40 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49535 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab0BOHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:17:39 -0500
Date: Mon, 15 Feb 2010 09:17:06 +0200
From: Jouni Malinen <j@w1.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Neuling <mikey@neuling.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, anton@samba.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space
 expansion to rlimit
Message-ID: <20100215071706.GB20814@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
 <12468.1266215420@neuling.org>
 <20100215155821.7298.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215155821.7298.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:59:26PM +0900, KOSAKI Motohiro wrote:

> -	rlim_stack = min(rlim_stack, stack_size);
> +	/*  Expand only to rlimit, making sure not to shrink it */
> +	rlim_stack = max(rlim_stack, stack_size);
> 
> is better fix?

Assuming I understood correctly that that was to replace the patch from
Michael completely and not just a part of it (i.e., just this one-liner
on top of linux-2.6.git), I can confirm that this, too, resolves the
issue I was seeing with UML.

-- 
Jouni Malinen                                            PGP id EFC895FA
