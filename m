Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0BOHMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:12:54 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40793 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052Ab0BOHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:12:50 -0500
Date: Mon, 15 Feb 2010 09:12:15 +0200
From: Jouni Malinen <j@w1.fi>
To: Michael Neuling <mikey@neuling.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       anton@samba.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space
 expansion to rlimit
Message-ID: <20100215071215.GA20814@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
 <12468.1266215420@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12468.1266215420@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 05:30:20PM +1100, Michael Neuling wrote:

> We got the logic wrong in one of the cleanups and hence we aren't
> actually changing the stack reservation ever, when we intended on
> allocating up to 20 new pages.  
> 
> The:
> 	rlim_stack = min(rlim_stack, stack_size);
> always chooses stack_size hence we end up not changing the stack at all.
> This seems to cause fatal problems on UML, but is obviously not what was
> intended for archs as well.  
> 
> The following works for me on PPC64 64k and 4k pages and UML on x86_64. 

That fixes my UML setup, too.

-- 
Jouni Malinen                                            PGP id EFC895FA
