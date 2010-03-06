Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0CFW5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:57:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0CFW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:57:52 -0500
Date: Sat, 6 Mar 2010 14:57:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros, recursive
 vsnprintf
In-Reply-To: <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>  <20100304143837.af39845d.akpm@linux-foundation.org>  <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>  <1267911399.849.39.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
 <1267914654.849.81.camel@Joe-Laptop.home> <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Linus Torvalds wrote:
> 
> I'm not convinced. We pass that 'printf_spec' around a lot, including 
> nesting. Not as a pointer, either.

Btw, I wonder if those fields could become bitfields, or 'unsigned char' 
etc. That printf_spec really is unnecessarily big. It should _easily_ fit 
in a single register on a 64-bit platform, possibly even a 32-bit one (we 
could limit field width and precision to 5 bits, for example)

			Linus
