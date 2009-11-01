Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZKAPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZKAPGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZKAPGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:06:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:55601 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZKAPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:06:46 -0500
Subject: Re: [PATCH] proc: fix ->stack_start in compat mode
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091101124301.GA16100@x200>
References: <20091028115602.GA26295@x200> <1257069245.3975.6.camel@wall-e>
	 <20091101124301.GA16100@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 01 Nov 2009 16:06:46 +0100
Message-ID: <1257088006.9292.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 01.11.2009, 15:43 +0300 schrieb Alexey Dobriyan:
> > >  Stefani, I get "Stack usage: 0 kB", you may want to look at it.
> > > 
> > 
> > Under which circumstance do you get 0 kb reported? What is your system
> > (mmu/nommu, 32bit/64bit, architecture and so on).
> 
> Well, no wonder it doesn't work:
> 
> 	#define KSTK_ESP(tsk)           -1 /* sorry. doesn't work for syscall. */
> 
> How does it supposed to work on live task?

Okay, you are right. That's really strange. I just build a 64 bit kernel
i will try to fix this odd behavior. This is a break in the kernel API.
KSTP_ESP should return the value of the kernel stack and not a -1. Sh..


