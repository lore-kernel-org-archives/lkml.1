Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYKIUZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYKIUZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYKIUZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:25:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:53651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYKIUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:25:06 -0500
Date: Sun, 9 Nov 2008 12:25:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       JosephChan@via.com.tw, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-ID: <20081109122515.1deb9ec2@infradead.org>
In-Reply-To: <20081109113603.d45361ad.akpm@linux-foundation.org>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 11:36:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 9 Nov 2008 20:25:37 +0100 Bruno Pr__mont
> <bonbons@linux-vserver.org> wrote:
> 
> > The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE
> > bits; CURSOR_SIZE is defined as (8 * 1024). Using up twice 1k on
> > stack is too much for 4k-stack (though it works with 8k-stacks).
> 
> >  
> >  	if (viacursor.enable)
> 
> Is the ->fb_cursor handler allowed to perform GFP_KERNEL memory
> allocations?  It's never called from atomic contexts?

if it's allowed to do GFP_KERNEL memory allocations the statement that
it works with 8k stacks is a bit overstated... since irq's can come in
and take several KB of stack as well ;)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
