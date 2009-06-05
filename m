Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZFEDH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZFEDH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZFEDHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:07:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52555 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZFEDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:07:49 -0400
Date: Fri, 5 Jun 2009 12:06:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Julian Phillips <julian@quantumfyre.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A question about using a private anonymous mmap
Message-Id: <20090605120618.0c074050.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk>
References: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 17:48:29 +0100 (BST)
Julian Phillips <julian@quantumfyre.co.uk> wrote:

> I have a program which creates a reasonably large private anonymous map. 
> The program then writes into a few places in the map, but ends up reading 
> from all of them.
> 
> When I run this program on a system running 2.6.20.7 the process only ever 
> seems to use enough memory to hold the data that has actually been written 
> (well - in units of PAGE_SIZE).  When I run the program on a system 
> running 2.6.24.5 then as it reads the map the amount of memory used 
> continues to increase until the complete map has actually been allocated 
> (and since the total size is greater than the physically available RAM 
> causes swapping).  Basically I seem to be seeing copy-on-read instead of 
> copy-on-write type behaviour.
> 
> Is this an expected change, and is there any option I can tweak to get the 
> old behaviour back?
> 

It comes from removal of ZERO_PAGE.

IMHO, What you can do is mmap(/dev/zero, MAP_PRIVATE) instead of ANON.

Thanks,
-Kame

> TIA,
> 
> -- 
> Julian
> 
>   ---
> I can't die until the government finds a safe place to bury my liver.
>  		-- Phil Harris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

