Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZFOQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZFOQjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZFOQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:39:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbZFOQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:39:06 -0400
Date: Mon, 15 Jun 2009 09:38:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WARN(): add a \n to the message printk
In-Reply-To: <20090615000822.6e6bf282@infradead.org>
Message-ID: <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain>
References: <20090615000822.6e6bf282@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Arjan van de Ven wrote:
>  
> -	if (args)
> +	if (args) {
>  		vprintk(args->fmt, args->args);
> +		printk("\n");
> +	}

I really don't like this. What if the format already does have a '\n'? And 
what if some other CPU is printing at the same time?

I'd almost be open to adding a "flags" field to vprintk, and allow setting 
things like "finish line with \n" there. Or perhaps even better, have a 
"vprintk_line()" function that does it with no dynamic flags. Maybe make 
it static, and move all these panic helper funtions into kernel/printk.c 
(since this really is a special case).	

I dunno. I'm just throwing out suggestions. I just don't think the above 
patch is very nice.

		Linus
