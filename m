Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbZI1Ezb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbZI1Ezb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZI1Ezb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:55:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44494 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZI1Eza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:55:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Sep 2009 13:53:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090928135315.083aca18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AC03D9C.3020907@crca.org.au>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC03D9C.3020907@crca.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 14:37:48 +1000
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi.
> 
> KAMEZAWA Hiroyuki wrote:
> > Then, Nigel, you have 2 choices I think.
> > 
> > (1) don't merge if vm_hints is set  or (2) pass vm_hints to all
> > __merge() functions.
> > 
> > One of above will be accesptable for stakeholders... I personally
> > like (1) but just trying (2) may be accepted.
> > 
> > What I dislike is making vm_flags to be long long ;)
> 
> Okay. I've gone for option 1 for now. Here's what I
> currently have (compile testing as I write)...
> 
> 
> 
> vm_flags in struct vm_area_struct is full. Move some of the less commonly
> used flags to a new variable so that other flags that need to be in vm_flags
> (because, for example, they need to be in variables that are passed around)
> can be added.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

Seems good to me.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
But
> +	if (vma->vm_hints)
> +		return 0;
>  	return 1;

Maybe adding a comment (or more detailed patch description) is necessary.

Regards,
-Kame

>  }
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

