Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZINOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZINOvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZINOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:51:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbZINOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:51:17 -0400
Date: Mon, 14 Sep 2009 07:50:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Anirban Sinha <ASinha@zeugmasystems.com>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] cleanup legacy console_print function
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F0FD30@exchange.ZeugmaSystems.local>
Message-ID: <alpine.LFD.2.01.0909140749300.3654@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <20090825172640.af8b9f58.randy.dunlap@oracle.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908271233580.3218@localhost.localdomain>
  <DDFD17CC94A9BD49A82147DDF7D545C501F0FD30@exchange.ZeugmaSystems.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Sep 2009, Anirban Sinha wrote:
>
> -           console_print(text); \
> -           console_print("\n"); \
> +           printk(KERN_EMERG "%s", text);      \
> +           printk(KERN_EMERG "\n");            \

Just clean it up to be

	printk(KERN_EMERG "%s\n", text);

instead while at it.

>  #define TRACE_CHR(chr) \
>  	{ \
>  	  if(dtlk_trace) \
> -	    console_print(chr); \
> +	    printk(KERN_EMERG "%c", chr); \

That can't be right. The translation is to use "%s", not "%c".

		Linus
