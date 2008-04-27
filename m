Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbYD0X0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbYD0X0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYD0X0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:26:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51375 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYD0X0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:26:36 -0400
Date: Sun, 27 Apr 2008 16:26:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
 architectures
Message-ID: <20080427162606.3dd82c0c@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org>
References: <20080427105100.GA14795@uranus.ravnborg.org>
	<20080427113158.GY2252@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org>
	<20080427172235.GA2252@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
	<20080427174714.GB2252@cs181133002.pp.htv.fi>
	<20080427180007.GB28483@infradead.org>
	<20080427180957.GA25964@uranus.ravnborg.org>
	<20080427181411.GA31667@infradead.org>
	<alpine.LFD.1.10.0804271118500.2896@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 11:24:28 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 27 Apr 2008, Christoph Hellwig wrote:
> > 
> > As Linus mentioned the hint doesn't make any sense because gcc will
> > get it wrong anyway.  In fact when you look at kernel code it tends
> > to inline the everything and the kitchensink as long as there's just
> > one caller and this bloat the stack but doesn't inline where it
> > needs to.  Better don't try to mess with that and do it explicit.
> 
> The thing is, the "inline" vs "always_inline" thing _could_ make
> sense, but sadly doesn't much.
> 
> Part of it is that gcc imnsho inlines too aggressively anyway in the 
> absense of "inline",


yup.. but this patch doesn't change that... the "no inline keyword" case
is totally unaffected...


(actually, other than some obscure commandline options, the only sane way to
avoid gcc doing this too agressive is using -Os)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
