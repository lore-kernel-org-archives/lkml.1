Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZHZATI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZHZATI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZHZATH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:19:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbZHZATF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:19:05 -0400
Date: Tue, 25 Aug 2009 17:18:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Anirban Sinha <ASinha@zeugmasystems.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console_print: change the function api to make it have
 printk style interface
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local>
Message-ID: <alpine.LFD.2.01.0908251717230.3218@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Anirban Sinha wrote:
>  
> -void console_print(const char *s)
> +int console_print(const char *fmt, ...)
>  {
> -	printk(KERN_EMERG "%s", s);
> +	va_list args;
> +	int r;
> +	char _fmt[1024] = KERN_EMERG;

Don't do this. That's a 1kB stack frame right there. You'll overflow the 
stack very quickly.

			Linus
