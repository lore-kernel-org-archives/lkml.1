Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXHGXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXHGXbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbXHGXbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:31:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbXHGXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:31:04 -0400
Date: Tue, 7 Aug 2007 16:29:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
Message-Id: <20070807162940.74f536f8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708080115020.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	<20070807124009.9f6c2247.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708080115020.1817@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 01:16:49 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Tue, 7 Aug 2007, Andrew Morton wrote:
> 
> > I'd be surprised if there was significant overhead - the maximum frequency
> > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > overhead for that to cause problems, surely?
> > 
> > <thinks he's missing something again>
> 
> _Anybody_ has yet to answer what's wrong with adding a nanosleep() and 
> using that instead.
> 

You mean that the implementation could be simplified if msleep() were to
simply call do_nanosleep()?

That would work, although a bit of refactoring would be needed so that we
could implement the TASK_UNINTERRUPTIBLE msleep() that way.

